/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import CoreLocation

class ProfileViewController: UIViewController {

    @IBOutlet weak var demoToggle: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.hidden = false
        self.loginButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationItem.title = NSLocalizedString("PROFILE", comment:"")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 22)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if(UserAuthHelper.isLoggedIn() == true){
            
            self.loginButton.hidden = true
       }
    }
    
    
    /**
    func to hide the login button after logging in
    
    :param: sender
    */
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if (UserAuthHelper.checkIfLoggedIn(self)) {
            //user is logged in
            self.loginButton.hidden = true
        }
    }

    
    /**
    func to show notification from xtify once the user minimizes the app
    
    :param: sender
    */
    @IBAction func toggleDemoMode(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (self.demoToggle.on == true) {
            appDelegate.demoModeWillSendNotification = true
            //below is a fix for iOS 7 to receive xtify notification in foreground to be able to display in background
                XtifyHelper.resetLocationForDemo()
                XtifyHelper.updateNearSummitStore()
        }
        else {
            appDelegate.demoModeWillSendNotification = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
