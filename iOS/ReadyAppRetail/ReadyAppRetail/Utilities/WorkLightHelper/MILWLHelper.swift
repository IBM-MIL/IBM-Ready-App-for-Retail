/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/
import UIKit

public class MILWLHelper: NSObject {

    /**
    This method is invoked from the loginViewController. It makes a call to Worklight with the email and password the user has entered. It sets the loginViewController to be the delegate to handle the callback from this call.
    
    :param: email    the email the user has entered in the emailTextField of the loginViewController
    :param: password the password the user has entered in the passwordTextField of the loginViewController
    :param: delegate the loginViewControlller that will handle the callback from this call to Worklight
    */
    class func login(email : String, password : String, callBack : ((Bool, String?)->())!){
        var loginManager : LoginManager = LoginManager()
        loginManager.callBack = callBack
        var adapterName : String = "SummitAdapter"
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "submitAuthentication")
        invocationData.parameters = [email, password]
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: loginManager)
    }
    
    
    /**
    This method is invoked from the BrowseViewController. It makes a call to Worklight for data to populate the collection views on the BrowseViewController.
    
    :param: callBack the browseviewcontroller that needs to recieve a call back when the requested data is recieved
    */
    class func getHomeViewMetadata(callBack : BrowseViewController){
        var homeViewMetadataManager : HomeViewMetadataManager = HomeViewMetadataManager()
        homeViewMetadataManager.callBack = callBack
        
        var adapterName : String = "SummitAdapter"
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "getHomeViewMetadata")
         invocationData.parameters = []
        
        var number : NSNumber = NSNumber(double: 30000)
        
        var timeout = Dictionary<String, NSNumber>()
        timeout["timeout"] = number
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: homeViewMetadataManager, options: timeout)
    }

    
    
    
    /**
    This method is invoked by the ProductDetailViewController. It makes a call to Worklight to get information about the product Id recieved as a parameter.
    
    :param: id       the id of the product to get information for
    :param: callBack the ProductDetailViewController to recieve data back from this call.
    */
    class func getProductById(id : NSString, callBack : ((Bool, JSON?)->())!){
        
        //getProductByIdDataManager will handle the call back from Worklight to handle the response data
        var getProductByIdDataManager : GetProductByIdDataManager = GetProductByIdDataManager()
        var adapterName : String = "SummitAdapter"
        
        getProductByIdDataManager.callBack = callBack
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "getProductById")
        invocationData.parameters = [id]
        
        var number : NSNumber = NSNumber(double: 30000)
        
        var timeout = Dictionary<String, NSNumber>()
        timeout["timeout"] = number
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: getProductByIdDataManager, options: timeout)
    }
    
    
    
    /**
    This method is invoked by the loginViewController. It makes a call to Worklight for the default list's of the user.
    
    :param: callBack the loginViewController to recieve data back from this call
    */
    class func getDefaultList(callBack : ((Bool)->())!){
        
         //getDefaultListDataManager will handle the call back from Worklight to handle the response data
        var getDefaultListDataManager : GetDefaultListDataManager = GetDefaultListDataManager()
        var adapterName : String = "SummitAdapter"
        
        getDefaultListDataManager.callback = callBack
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "getDefaultList")
        var userId : String = NSUserDefaults.standardUserDefaults().stringForKey("userID")!
        invocationData.parameters = [userId]
        
        var number : NSNumber = NSNumber(double: 70000)
        
        var timeout = Dictionary<String, NSNumber>()
        timeout["timeout"] = number
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: getDefaultListDataManager, options: timeout)
    }
    
    

    /**
    This method is invoked by the ProductDetailViewController. Since this is a protected call it first calls the isLoggedIn method from the Utils class to see if the user is logged in. Unfortunatly since the Worklight API can timeout the user authentication after a certain period of time, there is a chance that the isLoggedIn method will return true, even though the user is time'd out via Worklight since the Mobile First time out doesn't clear the NSUserDefaults that the isLoggedIn method depends on. For this case, the ReadyAppsChallengeHandler will handle this by disregarding this procedure call and continuing to inject json data to the hybrid view without product availability.
    :param: productId the productId to find availability for
    :param: callback  the productdetailview controller to give data back from this call
    
    :returns: bool representing if this call was success for or not depending on if the user is logged in
    */
    class func productIsAvailable(productId : NSString, callback : ProductDetailViewController) -> Bool{
        
        if(UserAuthHelper.isLoggedIn() == true){
        
            //productIsAvailableDataManager will handle the call back from Worklight to handle the response data
            var productIsAvailableDataManager : ProductIsAvailableDataManager = ProductIsAvailableDataManager()
            var adapterName : String = "SummitAdapter"
            
            productIsAvailableDataManager.callBack = callback
        
            let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "productIsAvailable")
            var userId : String = NSUserDefaults.standardUserDefaults().stringForKey("userID")!
            invocationData.parameters = [userId, productId]
        
            var number : NSNumber = NSNumber(double: 30000)
        
            var timeout = Dictionary<String, NSNumber>()
            timeout["timeout"] = number
        
            WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: productIsAvailableDataManager, options: timeout)
                return true
            }
        else{
                return false
            }
    }
    
    
    /**
    This method is invoked by the BrowseViewController. It makes a call to Worklight to get all the departments.
    
    :param: callback the browse view controller to recieve data back from this call
    */
    class func getAllDepartments(callback : BrowseViewController){
        
        //getAllDepartmentsDataManager will handle the call back from Worklight to handle the response data
        var getAllDepartmentsDataManager : GetAllDepartmentsDataManager = GetAllDepartmentsDataManager()
        var adapterName : String = "SummitAdapter"
        
        getAllDepartmentsDataManager.callBack = callback
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: "getAllDepartments")
        
        var number : NSNumber = NSNumber(double: 30000)
        
        var timeout = Dictionary<String, NSNumber>()
        timeout["timeout"] = number
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: getAllDepartmentsDataManager, options: timeout)
        
    }
}



/**
*  The LoginManager will recieve a call back from Worklightfrom the submitAuthentication procedure
*/
class LoginManager: NSObject, WLDelegate {
    
    var callBack : ((Bool, String?)->())!
    
    /**
    This method handles a successfull callback from Worklight. It uses JSONParseHelper to parse the user id from the response json. It then calls UserAuthHelper's saveUser method to save the userId to NSUserDefaults. After it calls the loginViewController callback's loginSuccessful method.
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
       
        var userID = JSONParseHelper.parseUserId(response)
        
        UserAuthHelper.saveUser(userID)
        
        self.callBack(true, nil)
    }
    
    /**
    This method handles the failure callback from Worklight. It first calls the JSONParseHelper's parseLoginFailureResponse method to parse the response json. It then calls the loginViewController callback's loginFailure method passing it the parsed error message from the response json.
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
        
        var errorMessage = JSONParseHelper.parseLoginFailureResponse(response)
     
        self.callBack(false, errorMessage)
    }
    
    
}


/**
*  The HomeViewMetadataManager will recieve a call back from Worklight from the getHomeViewMetadata procedure
*/
class HomeViewMetadataManager: NSObject, WLDelegate {
    
    var callBack : BrowseViewController!
    
    /**
    This method handles a successfull callback from Worklight. It uses JsonParseHelper to parse the json recieved and then tells the callback view controller (BrowseViewController in this case) to refresh the collectionviews with the parsed data from the jsonParseHelper.
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
        self.callBack.refreshCollectionViews(JSONParseHelper.parseHomeViewMetadataJSON(response))
    }
    
    /**
    This method handles the failure callback from Worklight. It calls the callback's  (BrowseViewController) failureGettingHomeViewMetaData method
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
        
        self.callBack.failureGettingHomeViewMetaData()
  
    }
    
}


/**
*  The GetProductByIdDataManager will recieve a call back from Worklightfrom the getProductById procedure
*/
class GetProductByIdDataManager: NSObject, WLDelegate {
   
//    var callBack : ProductDetailViewController!
    var callBack : ((Bool, JSON?)->())!
    
    /**
    This method handles a successfull callback from Worklight. It uses JsonParseHelper to parse the json recieved and then returns this data to the callback view controller
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
        
        var json = JSONParseHelper.massageProductDetailJSON(response)
        self.callBack(true, json)
        //self.callBack.receiveProductDetailJSON(json)
       
    }
    
    /**
    This method handles the failure callback from Worklight. It calls the callback's (ProductDetailViewController) failureGettingProductById method.
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
        
        self.callBack(false, nil)
        //self.callBack.failureGettingProductById()
    
    }
    
}


/**
*  The GetDefaultListDataManager will recieve a call back from Worklight from the getDefaultList procedure. It calls the callback's  (BrowseViewController) failureDownloadingDefaultLists method

*/
class GetDefaultListDataManager: NSObject, WLDelegate {
    
    var callback: ((Bool)->())!
    
    /**
    This method handles a successfull callback from Worklight. It uses JsonParseHelper to parse the json recieved and then returns this data to the callback view controller
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
        
        JSONParseHelper.parseDefaultListJSON(response)
        self.callback(true)
        
    }
    
    /**
    This method handles the failure callback from Worklight. It calls the callback's (loginViewController) failureDownloadingDefaultLists method.
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
        
        self.callback(false)
    }
    
}


/**
*  The ProductIsAvailableDataManager will recieve a call back from Worklight from the productIsAvailable procedure
*/
class ProductIsAvailableDataManager: NSObject, WLDelegate {
    
    var callBack : ProductDetailViewController!
    
    /**
    This method handles a successfull callback from Worklight. It uses JsonParseHelper to parse the json recieved and then returns this data to the callback view controller
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
        
        var availability = JSONParseHelper.parseAvailabilityJSON(response)
    
        callBack.recieveProductAvailability(availability)
    }
    
   
    /**
    This method handles the failure callback from Worklight. It calls the callback's (ProductDetailViewController) failureGettingProductAvailability method.
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
        self.callBack.failureGettingProductAvailability()
    }
    
}

/**
*  The GetAllDepartmentsDataManager will recieve a call back from Worklight from the getAllDepartmentsDataManager procedure
*/
class GetAllDepartmentsDataManager: NSObject, WLDelegate {
    
    var callBack : BrowseViewController!
    
    /**
    This method handles a successfull callback from Worklight. It uses JsonParseHelper to parse the json recieved and then returns this data to the callback view controller
    
    :param: response the response data recieved from Worklight
    */
    func onSuccess(response: WLResponse!) {
        
        var departmentArray : Array<String> = JSONParseHelper.parseAllDepartments(response)
    
        callBack.receiveDepartments(departmentArray)
    }
    
    
    /**
    This method handles the failure callback from Worklight. It calls the callback's (BrowseViewController) failureGettingAllDepartments method. 
    
    :param: response the response data recieved from Worklight
    */
    func onFailure(response: WLFailResponse!) {
     
        self.callBack.failureGettingAllDepartments()
        
    }
    
}







