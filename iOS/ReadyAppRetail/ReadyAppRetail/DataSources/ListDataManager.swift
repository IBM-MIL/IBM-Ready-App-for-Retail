/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

public class ListDataManager: NSObject {
    
    var callback: ((Bool)->())!
    
    public class var sharedInstance: ListDataManager {
        struct Singleton {
            static let instance = ListDataManager()
        }
        return Singleton.instance
    }
    
    /**
    This method is invoked by the loginViewController. It makes a call to Worklight for the default list's of the user.
    
    :param: callBack the loginViewController to recieve data back from this call
    */
    public func getDefaultList(callback : ((Bool)->())!){
        
        var adapterName : String = "SummitAdapter"
        var procedureName: String = "getDefaultList"
        
        self.callback = callback
        
        var sharedDefaults = NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!
        var userID: String = sharedDefaults.stringForKey("userID")!

        let params = [userID]
        
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName)
        caller.invokeWithResponse(self, params: params)
    }
   
}

// MARK: WLDataDelegate

extension ListDataManager: WLDataDelegate {
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    :param: response Response from WorkLight
    */
    public func onSuccess(response: WLResponse!) {
        
        JSONParseHelper.parseDefaultListJSON(response)
        
        // Execute the callback from the view controller that instantiated the dashboard call
        callback(true)
        
    }
    
    /**
    Delgate method for WorkLight. Called when connection or return is unsuccessful
    
    :param: response Response from WorkLight
    */
    public func onFailure(response: WLFailResponse!) {
        
        if (response.errorCode.value == 0) && (response.errorMsg != nil) {
            println("Response Failure with error: \(response.errorMsg)")
        }
        
        callback(false)
        
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