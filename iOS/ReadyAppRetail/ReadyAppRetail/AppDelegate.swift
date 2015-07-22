/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconManager: BeaconManager?
    var productDetailViewController : ProductDetailViewController!
    var demoModeWillSendNotification : Bool = false
    
   
    override init() {
        var anXtifyOptions = XLXtifyOptions.getXtifyOptions()
        XLappMgr.get().initilizeXoptions(anXtifyOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Succeeded registering for push notifications. Dev Token: \(deviceToken)")
        XLappMgr.get().registerWithXtify(deviceToken)
        
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Receiving notification, app is running")
        var launchOptions = userInfo
        self.handleAnyNotification(launchOptions)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to register with error: \(error)")
        XLappMgr.get().registerWithXtify(nil)
    }
    
    func handleAnyNotification(receivedData: Dictionary<NSObject,AnyObject>) {
        
        XLappMgr.get().insertNotificationClick(receivedData)
      
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Tell Realm to install in the app group
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(GroupDataAccess.sharedInstance.groupAppID)!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        
        // Do Realm migration
        RLMRealm.setSchemaVersion(1, forRealmAtPath: RLMRealm.defaultRealmPath(), withMigrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(Product.className()) { oldObject, newObject in
                    newObject["checkedOff"] = ""
                }
            }
        })
        
        // Check for first run
        if (NSUserDefaults.standardUserDefaults().objectForKey("summitFirstRun") == nil) {
            KeychainWrapper.removeObjectForKey("summit_username")
            KeychainWrapper.removeObjectForKey("summit_password")
            NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!.removeObjectForKey("userID")
            NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!.synchronize()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "summitFirstRun")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // Delete all the objects in the default Realm
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            realm.commitWriteTransaction()
        }
        
         UserAuthHelper.clearUser() //clear nsuserdefaults so user is forced to login everytime the user opens the app
        
        //white status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //setup for MQA
        //Read configurations from the Config.plist
        self.setUpMQA()
        
        OCLogger.setAutoSendLogs(false)
        OCLogger.setAutoUpdateConfigFromServer(false)
        OCLogger.setLevel(OCLogger_TRACE)
        
        self.registerChallengeHander()
        
        return true
    }
    
    
    /**
    This method sets up MQA. If isDevelopment is set to true in info.plist, MQA isn't set up, else it is.
    */
    private func setUpMQA(){
        if(Utils.isDevelopment() != true){
        var configurationPath = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        var mqaApplicationKey : String = ""
        
        var hasValidConfiguation = true
        var errorMessage = ""
        
        if((configurationPath) != nil) {
            var configuration = NSDictionary(contentsOfFile: configurationPath!)!
            
            mqaApplicationKey = configuration["mqaApplicationKey"] as! String
            if(mqaApplicationKey == ""){
                hasValidConfiguation = false
                errorMessage = "Open the Config.plist file and set the mqaId to the MQA application key"
            }
        }
        if(hasValidConfiguation){
            
            MQALogger.startNewSessionWithApplicationKey(mqaApplicationKey)
            
            NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        }else{
            NSException().raise()
        }
        }
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    /**
    This method registers the challenge handler needed for worklight when a user times out
    */
    private func registerChallengeHander(){
        var challengeHandler = ReadyAppsChallengeHandler()
        WLClient.sharedInstance().registerChallengeHandler(challengeHandler)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    /**
    If demo mode is one, an xtify notification will be sent to the user when the user puts the app in the background
    
    :param: application 
    */
    func applicationDidEnterBackground(application: UIApplication) {
        XLappMgr.get().appEnterBackground()
        
        if (self.demoModeWillSendNotification == true){  //if demo mode is on, show notification upon entering background
            XtifyHelper.resetLocationForDemo()

            XtifyHelper.updateNearSummitStore()
        }
        
    }
    

    func applicationWillEnterForeground(application: UIApplication) {
        
        XLappMgr.get().appEnterForeground()

    }
    
    func applicationDidBecomeActive(application: UIApplication) {

        if (self.demoModeWillSendNotification == true){  //if demo mode is on, show notification upon entering background
            XtifyHelper.resetLocationForDemo()
   
            XtifyHelper.updateNearSummitStore()
        }
        XLappMgr.get().appEnterActive()
        
    }
    
    func applicationWillTerminate(application: UIApplication) {

        XLappMgr.get().applicationWillTerminate()
        
        UserAuthHelper.clearUser() //clear nsuserdefaults so the user is forced to login everytime they open the app
    }
    
    // MARK: WatchKit related methods
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {

        if let infoDictionary = userInfo as? [String: AnyObject], dataAction = infoDictionary[WatchKitRequestIdentifierKey] as? String {
            
            // Handle data actions watch app might require
            if dataAction == WatchKitGetLists {
            
                WKProcedures.loginThroughWatch(reply, dataAction: dataAction)

            }
            
        }
    }
    
    // MARK: Handoff Communication
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        
        if let userInfo = userActivity.userInfo {
        
            if let window = self.window {
                
                if userActivity.activityType == HandoffListsID {
                    // This activity navigates to the List tab, either presenting the login or the lists if already authenticated
                    if let tabBarVC = window.rootViewController as? UITabBarController {
                        tabBarVC.selectedIndex = 1
                    }
                } else if userActivity.activityType == HandoffProductID {
                    
                    if let tabBarVC = window.rootViewController as? UITabBarController {
                        // This activity navigates to a product page
                        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        var productDetailVC = storyboard.instantiateViewControllerWithIdentifier("ProductDetailViewController") as? ProductDetailViewController
                        productDetailVC?.productId = userInfo[HandoffProductIDSubKey] as! NSString
                        
                        tabBarVC.selectedIndex = 0
                        tabBarVC.viewControllers?.first!.popToRootViewControllerAnimated(false)
                        tabBarVC.viewControllers?.first!.pushViewController(productDetailVC!, animated: false)
                        
                    }
                    
                }
            }
            
        }
        
        return true
    }

}

