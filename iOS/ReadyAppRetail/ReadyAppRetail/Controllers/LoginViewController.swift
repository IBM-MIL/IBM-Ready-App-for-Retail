/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Security

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet weak var loginBoxView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var summitLogoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var logoHolderTopSpace: NSLayoutConstraint!
    @IBOutlet weak var loginBoxViewBottomSpace: NSLayoutConstraint!
    
    var logoHolderOriginalTopSpace : CGFloat!
    var loginBoxViewOriginalBottomSpace : CGFloat!
    var kFourInchIphoneHeight : CGFloat = 568
    var kFourInchIphoneLogoHolderNewTopSpace : CGFloat = 30
    var kloginBoxViewPaddingFromKeyboard : CGFloat = 60
    var presentingVC : UIViewController!
    
    var noKeychainItems : Bool = true
    
    var wormhole : MMWormhole?
    
    
    /**
    This method calls the setUpLoginBoxView, setUpSignUpButton, setUpTextFields, and saveUIElementOriginalConstraints methods when the view loads
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wormhole = MMWormhole(applicationGroupIdentifier: GroupDataAccess.sharedInstance.groupAppID, optionalDirectory: nil)
        
        setUpLoginBoxView()
        setUpLoginButton()
        setUpSignUpButton()
        setUpTextFields()
        saveUIElementOriginalConstraints()
    }
   
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.title = NSLocalizedString("LOGIN", comment:"")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 22)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    
    /**
    This method calls the registerForKeyboardNotifications when the viewWillAppear
    
    :param: animated
    */
    override func viewWillAppear(animated: Bool) {
        self.registerForKeyboardNotifications()
        
        // Attempt to fetch login details from the keychain
        
        var usr : String? = KeychainWrapper.stringForKey("summit_username")
        var pswd : String? = KeychainWrapper.stringForKey("summit_password")
        
        if (usr != nil && pswd != nil) {
            Utils.showProgressHud()
            self.noKeychainItems = false
            MILWLHelper.login(usr!, password: pswd!, callBack: self.loginCallback)
        } else {
            self.noKeychainItems = true
        }
    }
    
    
    /**
    This method calls the deregisterFromKeyboardNotifications when the viewWillDisappear
    
    :param: animated
    */
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    This method sets up properties of the loginBoxView, specifically to make the corners rounded
    */
    func setUpLoginBoxView(){
        loginBoxView.layer.cornerRadius = 6;
        loginBoxView.layer.masksToBounds = true;
    }
    
    /**
    This method sets the title of the login button using a localized string
    */
    func setUpLoginButton(){
        loginButton.setTitle(NSLocalizedString("L O G I N", comment: "Another word for sign in"), forState: UIControlState.Normal)
    }
    
    /**
    This method sets up the usernameTextField and the passwordTextField to make the corners rounded, to add the icon on the left side of the textfield, and to hide the iOS 8 suggested words toolbar
    */
    func setUpTextFields(){
        
        //*****set up usernameTextField*****
        
        //make cursor color summit green
        usernameTextField.tintColor = Utils.UIColorFromHex(0x005448, alpha: 1)
        
        //create imageView of usernameIcon
        var usernameIconImageView = UIImageView(frame: CGRectMake(13, 12, 16, 20))
        usernameIconImageView.image = UIImage(named: "profile_selected")
        
        //create paddingView that will be added to the usernameTextField. This paddingView will hold the usernameIconImageView
        var usernamePaddingView = UIView(frame: CGRectMake(0, 0,usernameTextField.frame.size.height - 10, usernameTextField.frame.size.height))
        usernamePaddingView.addSubview(usernameIconImageView)
        
        //add usernamePaddingView to usernameTextField.leftView
        usernameTextField.leftView = usernamePaddingView
        usernameTextField.leftViewMode = UITextFieldViewMode.Always
        
        //make usernameTextField have rounded corners
        usernameTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        //hide iOS 8 suggested words toolbar
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No;
        
        usernameTextField.placeholder = NSLocalizedString("Username", comment: "A word for mail over the internet")
        
      
        //*****set up passwordTextField****
        
        //make cursor color summit green
        passwordTextField.tintColor = Utils.UIColorFromHex(0x005448, alpha: 1)
        //create imageView for passwordIcon
        var passwordIconImageView = UIImageView(frame: CGRectMake(13, 10, 18, 22))
        passwordIconImageView.image = UIImage(named: "password")
        
        //create paddingView that will be added to the passwordTextField. This paddingView will hold the passwordIconImageView
        var passwordPaddingView = UIView(frame: CGRectMake(0, 0,usernameTextField.frame.size.height - 10, usernameTextField.frame.size.height))
        passwordPaddingView.addSubview(passwordIconImageView)
        
        //add passwordPaddingView to the passwordTextField.left
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        //Make passwordTextField have rounded corners
        passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        //hide iOS 8 suggested words toolbar
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No;
        
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "A secret phrase that allows you to login to a service")

        
    }
    
    /**
    This method sets up the text of the signUpButton by creating an attributed string and assigning this attributed string to the signUpButtons attributed title
    */
    func setUpSignUpButton(){
        // create attributed string
        let localizedString = NSLocalizedString("Don't have an Account?", comment: "A secret phrase that allows you to login to a service")
        let string = localizedString
        var attributedString = NSMutableAttributedString(string: string)
        
        let localizedString2 = NSLocalizedString(" Sign Up.", comment: "A secret phrase that allows you to login to a service")
        let string2 = localizedString2
        var attributedString2 = NSMutableAttributedString(string: string2)
        
        // create font descriptor for bold and italic font
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let boldItalicFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
        
        //Create attributes for two parts of the string
        let firstAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let secondAttributes = [NSFontAttributeName: UIFont(descriptor: boldItalicFontDescriptor!, size: 12), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Add attributes to two parts of the string
        attributedString.addAttributes(firstAttributes, range: NSRange(location: 0,length: count(string)))
        attributedString2.addAttributes(secondAttributes, range: NSRange(location: 0, length: count(string2)))
        
        attributedString.appendAttributedString(attributedString2)
        
        //set Attributed Title for signUp Button
        signUpButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
    }
    
    /**
    This method saves the original constant for the the logoHolderOriginalTopSpace and the loginBoxViewOriginalBottomSpace. These CGFloats are needed in the keyboardWillHide method to bring the logoHolder and the loginBoxView back to their original constraint constants.
    */
    func saveUIElementOriginalConstraints(){
        logoHolderOriginalTopSpace = logoHolderTopSpace.constant
        loginBoxViewOriginalBottomSpace = loginBoxViewBottomSpace.constant
    }
    /**
    This method sets up the keyboardWillShow and keyboardWillHide methods to be called when NSNotificationCenter triggers the UIKeyboardWillShowNotification and UIKeyboardWillHideNotification notifications repspectively
    */
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    /**
    This method removes the observer that triggers the UIKeyboardWillShowNotification. This method is invoked in the viewWillDisappear method
    */
    func deregisterFromKeyboardNotifications(){
         NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil);
    }
    
    /**
    This method is called when the loginButton is pressed. This method checks to see if the username and password entered in the textfields are of valid syntax. It does this by calling the checkEmail and checkPassword methods of the utility class SyntaxChecker.swift. This class assumes that the following regular expression is allowed for an email [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4} and for a password [A-Z0-9a-z_@!&%$#*?]+. This method also calls the login method
    
    :param: sender
    */
    @IBAction func loginButtonAction(sender: UIButton) {
        
        if(SyntaxChecker.checkUserName(usernameTextField.text) == true && SyntaxChecker.checkPassword(passwordTextField.text) == true){
                self.login()
        }
        
    }
    
    
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
    
    
    
    /**
    This method uses the view controllers instance of milWLHelper to call the login method, passing it the username and password the user entered in the text fields.
    */
    func login(){
        Utils.showProgressHud()
        MILWLHelper.login(self.usernameTextField.text, password: self.passwordTextField.text, callBack: self.loginCallback)
    }
    
    func loginCallback(success: Bool, errorMessage: String?) {
        if success {
            self.loginSuccessful()
        }
        else if (errorMessage != nil) {
            self.loginFailure(errorMessage!)
        }
        else {
            self.loginFailure("No message")
        }
    }
    
    
    /**
    This method is called from the LoginManager if the login was successful
    */
    func loginSuccessful(){
        
        // Store username and password in the keychain
        if (noKeychainItems == true) {
            KeychainWrapper.setString(self.usernameTextField.text, forKey: "summit_username")
            KeychainWrapper.setString(self.passwordTextField.text, forKey: "summit_password")
        }
        
        // Let the Watch know that it can log in
        self.wormhole!.passMessageObject(["username": KeychainWrapper.stringForKey("summit_username")!, "password": KeychainWrapper.stringForKey("summit_password")!], identifier: "loginNotification")
        
        MILWLHelper.getDefaultList(self.defaultListResult)
    }
    
    func defaultListResult(success: Bool) {
        if success {
            self.defaultListsDownloaded()
        } else {
            self.failureDownloadingDefaultLists()
        }
    }
    
    private func dismissLoginViewController(){
        Utils.dismissProgressHud()
        //dismiss login and present the appropriate next view based on which VC presented the login
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion:{(Bool) in
            
            if (self.presentingVC.isKindOfClass(ProductDetailViewController)) {
                var detailVC: ProductDetailViewController = self.presentingVC as! ProductDetailViewController
                detailVC.queryProductIsAvailable() //refresh product availability
                detailVC.addToListTapped() //show add to list view
                
                
            }
            
            if (self.presentingVC.isKindOfClass(ListTableViewController)) {
                var detailVC: ListTableViewController = self.presentingVC as! ListTableViewController
                detailVC.performSegueWithIdentifier("createList", sender: self) //show create a list view
            }
            
        })
    }
    
    /**
    This method is called from the GetDefaultListDataManager when the lists have been successfully downloaded, parsed, and added to realm
    */
    func defaultListsDownloaded(){
        Utils.dismissProgressHud()
        dismissLoginViewController()
    }
    
    
    /**
    This method is called by the GetDefaultListDataManager when the onFailure was called by Worklight. It first dismisses the progressHud and then shows the server error alert
    */
    func failureDownloadingDefaultLists(){
        Utils.dismissProgressHud()
        Utils.showServerErrorAlert(self, tag: 1)
    }
    
    /**
    This method is called when the Retry button is pressed from the server error alert. It first shows the progressHud and then retrys to call MILWLHelper's getDefaultList method
    
    :param: alertView
    :param: buttonIndex
    */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(alertView.tag == 1){
            Utils.showProgressHud()
             MILWLHelper.getDefaultList(self.defaultListResult)
        }
    }
    
    /**
    This method is called from the LoginManager if the login was a failure
    */
    func loginFailure(errorMessage : String){
        
        Utils.dismissProgressHud()
        
        var alertTitle : String!
        
        if(errorMessage == NSLocalizedString("Invalid username", comment:"")){
            
            if (self.noKeychainItems == false) {
                alertTitle = NSLocalizedString("Stale Keychain Credentials", comment:"")
                KeychainWrapper.removeObjectForKey("summit_username")
                KeychainWrapper.removeObjectForKey("summit_password")
                self.noKeychainItems = true
            }
            
            alertTitle = NSLocalizedString("Invalid Username", comment:"")
        }
        else if(errorMessage == "Invalid password"){
            if (self.noKeychainItems == false) {
                alertTitle = NSLocalizedString("Stale Keychain Credentials", comment:"")
                KeychainWrapper.removeObjectForKey("summit_username")
                KeychainWrapper.removeObjectForKey("summit_password")
                self.noKeychainItems = true
            }
            
            alertTitle = NSLocalizedString("Invalid Password", comment:"")
        }
        else {
            alertTitle = NSLocalizedString("Can't Connect To Server", comment:"")
        }
        
        var alert = UIAlertView()
        alert.title = alertTitle
        alert.message = NSLocalizedString("Please Try Again", comment:"")
        alert.addButtonWithTitle("OK")
        alert.show()
        Utils.dismissProgressHud()
    }
    

    /**
    This method is called when the signUpButton is pressed
    
    :param: sender
    */
    @IBAction func signUpButtonAction(sender: UIButton) {
   
    }
    
    /**
    This method is called when the user touches anywhere on the view that is not a textfield. This method triggers the keyboard to go down, which triggers the keyboardWillHide method to be called, thus bringing the loginBoxView and the logoHolderView back to their original positions
    
    :param: touches
    :param: event
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    /**
    This method is called when the keyboard shows. Its main purpose is to adjust the logoHolderView and the loginBoxView's constraints to raise these views up vertically to make room for the keyboard
    
    :param: notification
    */
    func keyboardWillShow(notification : NSNotification){
        
        //if the loginBoxViewBottomSpace.constant is at its original position, aka only raise the views when they aren't already raised.
        if(loginBoxViewBottomSpace.constant == loginBoxViewOriginalBottomSpace){
            //if the iPhone's height is less than kFourInchIphoneHeight (568)
            if(UIScreen.mainScreen().bounds.height <= kFourInchIphoneHeight){
                var info : NSDictionary = notification.userInfo!
                //grab the size of the keyboard that has popped up
                var keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
                
                //adjust the top space constraint for the logoHolder
                logoHolderTopSpace.constant = kFourInchIphoneLogoHolderNewTopSpace
            
                //adjust the loginBoxView bottom space
                loginBoxViewBottomSpace.constant = (keyboardSize!.height - loginBoxViewBottomSpace.constant) + kloginBoxViewPaddingFromKeyboard  //arbitrary 20 padding
                UIView.animateWithDuration(0.3, animations: {
                    self.view.layoutIfNeeded()
                    self.appNameLabel.alpha = 0
                })
            
            }else{
                var info : NSDictionary = notification.userInfo!
                //grab the size of the keyboard
                var keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size
        
                self.view.layoutIfNeeded()
            
                //adjust the bottom space constraint for the loginBoxView
                loginBoxViewBottomSpace.constant = (keyboardSize!.height - loginBoxViewBottomSpace.constant) + kloginBoxViewPaddingFromKeyboard  //arbitrary 20 padding
                UIView.animateWithDuration(0.3, animations: { self.view.layoutIfNeeded()})
            }
        }
    }
    
    /**
    This method is called when the keyboard hides. It sets the logoHolderView and the loginBoxView's constraints to their original positions
    
    :param: notification
    */
    func keyboardWillHide(notification : NSNotification){
        self.view.layoutIfNeeded()
        
        //set the logoHolderTopSpace and loginBoxViewBottomSpace to their original constraint constants
        logoHolderTopSpace.constant = logoHolderOriginalTopSpace
        loginBoxViewBottomSpace.constant = loginBoxViewOriginalBottomSpace
        UIView.animateWithDuration(0.2, animations: { self.view.layoutIfNeeded()
        self.appNameLabel.alpha = 1
        })

    }
    
    /**
    If the user presses the return key while the passwordTextField is selected, it will call the login method
    
    :param: textField
    
    :returns:
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == passwordTextField){
            login()
        }
        return true
    }
    
    /**
    This method is called when the user presses the x in the top left corner
    
    :param: sender
    */
    @IBAction func cancelLoginScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
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
