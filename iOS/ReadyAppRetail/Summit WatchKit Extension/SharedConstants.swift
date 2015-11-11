/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


import Foundation

let WatchKitRequestIdentifierKey: String = "identifier"
let WatchKitRequestParametersKey: String = "parameters"

let WatchKitProductDetails: String = "productdetails"
let WatchKitGetLists: String = "getlists"

let WatchKitNotAuthenticated: String = "User not logged in"

// MARK: Handoff IDs

let HandoffListsID: String = "com.ibm.mil.summit.lists"
let HandoffProductID: String = "com.ibm.mil.summit.product"
let HandoffProductIDSubKey: String = "summit.productID"

// Plist Data Handler

class GroupDataAccess  {
    
    static let sharedInstance = GroupDataAccess()
    
    var groupAppID: String? {
        
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist"),
            let configuration = NSDictionary(contentsOfFile: path),
            let entry = configuration["sharedAppGroupID"] as? String
        {
            
            return entry
            
        } else {
            
            return nil
            
        }
        
    }
}