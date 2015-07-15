/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Class to handle data requests from WatchKit Extension
*/
class WKProcedures: NSObject {
    
    /**
    Watch helper method to perform summit authentication or inform user they need to login on the iPhone
    
    :param: reply      watchKitExtensionRequest callback to return results
    :param: dataAction category for type of request
    */
    class func loginThroughWatch(reply: (([NSObject : AnyObject]!) -> Void)!, dataAction: String) {
        
        if UserAuthHelper.isLoggedIn() {
            
            WKProcedures.getLists(reply, id: dataAction)
        } else {
            
            // Do login
            var usr : String? = KeychainWrapper.stringForKey("summit_username")
            var pswd : String? = KeychainWrapper.stringForKey("summit_password")
            
            if (usr != nil && pswd != nil) {
                
                /* Authenticate using credentials stored in Keychain */
                
                // Set up background task info
                var loginMfpTask: UIBackgroundTaskIdentifier!
                
                // completion block is never called, but necessary to pass in as Expiration Handler. Could be called if needed
                let completionBlock: () -> Void = {
                    reply(nil)
                    UIApplication.sharedApplication().endBackgroundTask(loginMfpTask)
                }
                // Warning: must perform long running network calls like MFP calls on background task!
                loginMfpTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(completionBlock)
                
                
                MILWLHelper.login(usr!, password: pswd!, callBack: { (success: Bool, errorMessage: String?) in
                    if success {
                        WKProcedures.getLists(reply, id: dataAction)
                        UIApplication.sharedApplication().endBackgroundTask(loginMfpTask)
                    }
                    else {
                        KeychainWrapper.removeObjectForKey("summit_username")
                        KeychainWrapper.removeObjectForKey("summit_password")
                        reply(["parentMessage" : "You need to log in on your phone"])
                        UIApplication.sharedApplication().endBackgroundTask(loginMfpTask)
                    }
                })
            }
            else {
                reply(["parentMessage" : WatchKitNotAuthenticated])
            }
        }
    }
    
    /**
    WatchKit helper method to perform MFP call to gather new lists and then return a list of lists, retrieved from Realm
    
    :param: reply      watchKitExtensionRequest callback to return results
    :param: dataAction category for type of request
    */
    class func getLists(reply: (([NSObject : AnyObject]!) -> Void)!, id: String) {
        
        // Set up background task info
        var mfpTask: UIBackgroundTaskIdentifier!
        
        // completion block is never called, but necessary to pass in as Expiration Handler. Could be called if needed
        let completionBlock: () -> Void = {
            reply(nil)
            UIApplication.sharedApplication().endBackgroundTask(mfpTask)
        }
        // Warning: must perform long running network calls like MFP calls on background task!
        mfpTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(completionBlock)
        
        MILWLHelper.getDefaultList({ done in
            
            if done {
                
                // Once any new lists are added to Realm, we pull all lists, sorted by name
                var dataArray = List.allObjects().sortedResultsUsingProperty("created", ascending: true)
                
                let userInfo: [NSObject:AnyObject] = [
                    "parentMessage": id,
                    "requestData": RealmHelper.encodeListsToJson(dataArray, listCount: 3).object
                ]
                
                // Sends 3 most recently created lists in Json
                reply(userInfo)
                UIApplication.sharedApplication().endBackgroundTask(mfpTask)
            } else {
                // Send back error message
                reply(["parentMessage" : "Did not work"])
                UIApplication.sharedApplication().endBackgroundTask(mfpTask)
            }
        })
    }
    
    // MARK: Currently Unused
    
    /**
    Method not currently needed and may be removed later
    Method to grab product data for id, may never need if everything is sent with list
    
    :param: reply  watchKitExtensionRequest callback to return results
    :param: json  Json passed in to parse out a productID
    */
    class func getProduct(reply: (([NSObject : AnyObject]!) -> Void)!, json: JSON) {
        
        if let productID = json["productId"].string {
            MILWLHelper.getProductById( NSString(string: productID) , callBack: { (success: Bool, jsonResult: JSON?) -> () in
                if success {
                    if let result = jsonResult {
                        var product = JSONParseHelper.parseProduct(result)
                        
                        // Only coerce data that we need otherwise it messes up
                        reply(["name": product.name, "price": product.price, "imageUrl": product.imageUrl, "rating": product.rev])
                    }
                } else {
                    reply(["parentMessage" : "Couldn't get product data"])
                }
                
            })
        }
    }
    
    // Would call the above like so, from the handleWatchKitExtension delegate method
    /*if dataAction == WatchKitProductDetails {
        var jsonData = JSON(infoDictionary[WatchKitRequestParametersKey]!)
        WKProcedures.getProduct(reply, json: jsonData)
    }*/
   
}
