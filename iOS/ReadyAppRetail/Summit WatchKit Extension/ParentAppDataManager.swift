/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import WatchKit

public class ParentAppDataManager: NSObject {
    
    var callback: (([NSObject : AnyObject]?)->())!
    
    public class var sharedInstance: ParentAppDataManager {
        struct Singleton {
            static let instance = ParentAppDataManager()
        }
        return Singleton.instance
    }
    
    func retryRequest(request: ParentDataRequest, retry: Bool) -> Bool {
        if retry {
            println("retrying request")
            self.execute(request, retry: false, result: self.callback)
            return false
        }
        
        return true
    }
    
    func execute(request: ParentDataRequest, retry: Bool, result: (([NSObject : AnyObject]?)->())!) {
        
        self.callback = result
        
        let userInfo: [String : AnyObject] = [
            WatchKitRequestIdentifierKey: request.identifier,
            WatchKitRequestParametersKey: request.jsonRepresentation().object
        ]
        
        let sent = WKInterfaceController.openParentApplication(userInfo, reply: { (replyDictionary, error) -> Void in
            
            if let error = error {
                println("Error in grabbing WatchKit Data: \(error)")
                
                // Parent calls usually fail the first time, not sure why. So we retry once
                if self.retryRequest(request, retry: retry) {
                    self.callback(nil)
                }
                
            } else if let response = replyDictionary {
                
                println("Response: \(response)")
                self.callback(response)
            } else {
                
                if self.retryRequest(request, retry: retry) {
                    self.callback(nil)
                }
            }
            
        })
        
        if !sent {
          self.callback(nil)
        }

    }
    
}
