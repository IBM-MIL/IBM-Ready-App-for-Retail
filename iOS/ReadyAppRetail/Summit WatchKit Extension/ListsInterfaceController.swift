/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation

class ListsInterfaceController: WKInterfaceController {
    
    func init() {
        var request = ListsDataRequest()
        ParentAppDataManager.sharedInstance.execute(request, retry: true)
    }
    
    // Allows interface update, given a context
    override func awakeWithContext(context: AnyObject?) {
        
    }
    
    // Called right before interface shows up
    override func willActivate() {
        
    }
    
    // Called when the interface goes away
    override func didDeactivate() {
        
    }
    
    
    
}