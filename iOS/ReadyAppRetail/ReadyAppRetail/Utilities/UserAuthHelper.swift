/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class UserAuthHelper: NSObject {
   
    static var hasKeychainItems : Bool = true
    
    /**
    This method checks to see if a user is logged in by calling the isLoggedIn method. If a user is logged in it returns true. If a user isn't logged in, it presents the loginViewController and returns false.
    
    :param: fromViewController the view controller that will present the loginViewController if a user isn't logged in
    
    :returns: bool true - user is logged in, false - user isn't logged in
    */
    class func checkIfLoggedIn(fromViewController:UIViewController) -> Bool {
        
        if(isLoggedIn() == true){
            return true
        }

        presentLoginViewController(fromViewController)
        return false
    }
    
    /**
    This method checks to see if a user is logged in by checking NSUserDefaults to see if there is a string for key "userID". If there is a value for this key, it checks to see if the value is greated than 0. If it isn't greater than 0 then it returns false, else true. If there is no string for Key "userID" then it returns false.
    
    :returns: bool true - user is logged in, false - user isn't logged in
    */
    class func isLoggedIn() -> Bool {
        if let name = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        {
            if(count(name) > 0){
                return true
            }
            else{
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    
    /**
    This method saves the userID parameter to NSUserDefaults for the key "userID"
    
    :param: userID the userID to be saved to NSUSerDefaults for key "userID"
    */
    class func saveUser(userID : String){
        NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "userID")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    /**
    This method sets the value for key "userID" to "" in NSUserDefaults
    */
    class func clearUser(){
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "userID")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    /**
    This method checks to see if a user has downloaded the defaultLists yet.
    
    :returns: bool true - user has downloaded default lists, false - user hasn't downloaded default lists
    */
    class func hasDownloadedDefaultLists() -> Bool{
        if let hasDownloadedDefaultLists = NSUserDefaults.standardUserDefaults().stringForKey("hasDownloadedDefaultLists")
        {
            if(hasDownloadedDefaultLists == "true"){
                return true
            }
            else{
                return false
            }
        }
        else
        {
            return false
        }
        
    }
    
    /**
    This method sets the key hasDownloadedDefaultLists to true in NSUserDefaults
    */
    class func setUserHasDownloadedDefaultLists(){
        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "hasDownloadedDefaultLists")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    /**
    This method is called by the checkIfLogged method. It is called when the user isn't logged in and the loginViewController should be presented.
    
    :param: fromViewController the view controller that will be presenting the loginViewController.
    */
    private class func presentLoginViewController(fromViewController:UIViewController) {
        var vc = fromViewController.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        vc.presentingVC = fromViewController
        fromViewController.presentViewController(vc, animated: true, completion: nil)
    }

    
    
}
