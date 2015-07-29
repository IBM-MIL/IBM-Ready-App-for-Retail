/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

public class LoginDataManager: NSObject {
    
    var callback : ((Bool, String?)->())!
    
    public class var sharedInstance: LoginDataManager {
        struct Singleton {
            static let instance = LoginDataManager()
        }
        return Singleton.instance
    }
    
    /**
    This method is invoked by the loginViewController. It makes a call to Worklight for the default list's of the user.
    
    :param: callBack the loginViewController to recieve data back from this call
    */
    public func login(email : String, password : String, callback : ((Bool, String?)->())!) {
        
        var adapterName : String = "SummitAdapter"
        var procedureName: String = "submitAuthentication"
        
        self.callback = callback
        
        let params = [email, password]
        
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName)
        caller.invokeWithResponse(self, params: params)
    }
    
}

// MARK: WLDataDelegate

extension LoginDataManager: WLDataDelegate {
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    :param: response Response from WorkLight
    */
    public func onSuccess(response: WLResponse!) {
        
        var userID = JSONParseHelper.parseUserId(response)
        
        //UserAuthHelper.saveUser(userID)
        
        var sharedDefaults = NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!
        sharedDefaults.setObject(userID, forKey: "userID")
        sharedDefaults.synchronize()
        
        // Execute the callback from the view controller that instantiated the dashboard call
        callback(true, nil)
        
    }
    
    /**
    Delgate method for WorkLight. Called when connection or return is unsuccessful
    
    :param: response Response from WorkLight
    */
    public func onFailure(response: WLFailResponse!) {
        
       var errorMessage = JSONParseHelper.parseLoginFailureResponse(response)
        
        callback(false, errorMessage)
        
    }
    
    
    /**
    Delgate method for WorkLight. Task to do before executing a call.
    */
    public func onPreExecute() {
    }
    
    /**
    Delgate method for WorkLight. Task to do after executing a call.
    */
    public func onPostExecute() {
    }
    
}