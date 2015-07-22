/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation
import Realm

class ListOverviewInterfaceController: WKInterfaceController {

    @IBOutlet weak var listsTable: WKInterfaceTable!
    @IBOutlet weak var loadingImage: WKInterfaceImage!
    @IBOutlet weak var centeringLabelView: WKInterfaceLabel!
    @IBOutlet weak var loginLabel: WKInterfaceLabel!
    @IBOutlet weak var addListsLabel: WKInterfaceLabel!
    @IBOutlet weak var retryButton: WKInterfaceButton!
    
    var realmLists: RLMResults?
    var defaults: NSUserDefaults?
    var wormhole: MMWormhole?
    
    // -------------------
    //      LIFECYCLE
    // -------------------
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.checkForFirstRun()
        self.setUpWormhole()
        self.setUpRealm()
        
        // Not yet logged in
        // NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userID")
        
        self.beginLoading()
    }
    
    override func willActivate() {
        super.willActivate()
        
        self.setTitle("Summit")
        
        // Do handoff and attempt to auth
        self.updateUserActivity(HandoffListsID, userInfo: [:], webpageURL:nil)
        
        self.refresh()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        // Deactivate handoff
        self.invalidateUserActivity()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "listSegue" {
            var listData: AnyObject = self.realmLists!.objectAtIndex(UInt(rowIndex))
            return listData
        }
        return nil
    }
    
    // ------------------
    //     NETWORKING
    // ------------------
    
    private func authenticate() {
        var usr : String? = KeychainWrapper.stringForKey("summit_username")
        var pswd : String? = KeychainWrapper.stringForKey("summit_password")
        
        var shouldBeAbleToLogin = false
        
        if (usr != nil && pswd != nil) {
            
            LoginDataManager.sharedInstance.login(usr!, password: pswd!, callback: { (success: Bool, errorMessage: String?) in
                if success {
                    // NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userID")
                    self.fetchLists()
                }
                else {
                    self.failedToAuth()
                    println("Keychain credentials were stale... not authenticiated")
                }
            })
        }
        else {
            self.failedToAuth()
            println("No keychain data was found... not authenticiated")
        }
    }
    
    private func fetchLists() {
        ListDataManager.sharedInstance.getDefaultList({ done in
        
            var usr : String? = KeychainWrapper.stringForKey("summit_username")
            var pswd : String? = KeychainWrapper.stringForKey("summit_password")
            
            if done {
                self.realmLists = List.allObjects().sortedResultsUsingProperty("name", ascending: true)
                
                self.createTable()
                self.presentLists()
            } else {
                println("Failed to fetch the lists... Perhaps the authentication is dead? Reattempting auth...")

                // Reattempt an authenticiation
                if (!self.isLoggedIn()) {
                    self.authenticate()
                }
            }
            
        })
    }
    
    private func createTable() {
        dispatch_async(dispatch_get_main_queue(),{
            
            var font = UIFont.systemFontOfSize(14)
            var attributeData = [NSFontAttributeName : font]
            var count = 0
            
            var imgNames: [String] = ["List_Background_A", "List_Background_B", "List_Background_C", "List_Background_D"]
            
            let numRows = Int(self.realmLists!.count > 20 ? 20 : self.realmLists!.count)
            self.listsTable.setNumberOfRows(numRows, withRowType: "ListRow")
            
            for (var i = 0 ; i < numRows ; i++) {
                if let row = self.listsTable.rowControllerAtIndex(i) as? ListRow {
                    
                    let list : List? = self.realmLists!.objectAtIndex(UInt(i)) as? List
                    
                    var labelText = NSAttributedString(string: list!.name as String, attributes: attributeData)
                    row.titleLabel.setAttributedText(labelText)
                    
                    // Set background image
                    row.listItemGroup.setBackgroundImageNamed(imgNames[i % 4])
                }
            }
            
            if (numRows <= 0) {
                self.addListsLabel.setHidden(false)
            }
            
        })
    }
    
    @IBAction private func retryListFetch() {
        self.beginLoading()
        self.fetchLists()
    }
    
    private func setUpWormhole() {
        self.wormhole = MMWormhole(applicationGroupIdentifier: GroupDataAccess.sharedInstance.groupAppID, optionalDirectory: nil)
        self.wormhole!.listenForMessageWithIdentifier("loginNotification", listener: { (messageObject) -> Void in
            
            if let message: Dictionary<String, AnyObject> = messageObject as? Dictionary<String, AnyObject> {
                
                if let username = message["username"] as? String {
                    KeychainWrapper.setString(username, forKey: "summit_username")
                }
                if let password = message["password"] as? String {
                    KeychainWrapper.setString(password, forKey: "summit_password")
                }
                
                self.beginLoading()
                self.authenticate()
            }
        })
        
        self.wormhole!.listenForMessageWithIdentifier("refreshLists", listener: { (messageObject) -> Void in
            self.refresh()
        })
    }
    
    private func setUpRealm() {
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
    }
    
    // ------------------
    //      HELPERS
    // ------------------
    
    private func beginLoading() {
        self.loadingImage.setHidden(false)
        self.centeringLabelView.setHidden(false)
        self.loginLabel.setHidden(true)
        self.listsTable.setHidden(true)
        self.retryButton.setHidden(true)
        self.addListsLabel.setHidden(true)
    
        self.loadingImage.setImageNamed("Activity")
        self.loadingImage.startAnimatingWithImagesInRange(NSMakeRange(0, 15), duration: 1.0, repeatCount: 0)
    }
    
    private func failedToAuth() {
        self.loginLabel.setHidden(false)
        self.loadingImage.setHidden(true)
        self.centeringLabelView.setHidden(true)
        self.listsTable.setHidden(true)
        self.retryButton.setHidden(true)
        self.addListsLabel.setHidden(true)
        
        self.loadingImage.stopAnimating()
        
        KeychainWrapper.removeObjectForKey("summit_username")
        KeychainWrapper.removeObjectForKey("summit_password")
    }
    
    private func presentLists() {
        self.listsTable.setHidden(false)
        self.loginLabel.setHidden(true)
        self.loadingImage.setHidden(true)
        self.centeringLabelView.setHidden(true)
        self.retryButton.setHidden(true)
        self.addListsLabel.setHidden(true)
        
        self.loadingImage.stopAnimating()
    }
    
    private func showRetryButton() {
        self.retryButton.setHidden(false)
        self.centeringLabelView.setHidden(false)
        self.listsTable.setHidden(true)
        self.loadingImage.setHidden(true)
        self.loginLabel.setHidden(true)
        self.addListsLabel.setHidden(true)
        
        self.loadingImage.stopAnimating()
    }
    
    private func checkForFirstRun() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("summitFirstRun") == nil) {
            KeychainWrapper.removeObjectForKey("summit_username")
            KeychainWrapper.removeObjectForKey("summit_password")
            NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!.removeObjectForKey("userID")
            NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!.synchronize()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "summitFirstRun")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private func isLoggedIn() -> Bool {
        if let name = NSUserDefaults(suiteName: GroupDataAccess.sharedInstance.groupAppID)!.stringForKey("userID") {
            if(count(name) > 0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func refresh() {
        if (!self.isLoggedIn()) {
            self.authenticate()
        } else {
            self.fetchLists()
        }
    }
    
}

