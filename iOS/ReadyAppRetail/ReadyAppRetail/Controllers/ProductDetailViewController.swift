/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ProductDetailViewController: MILWebViewController, MILWebViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var addToListContainerView: UIView!

    @IBOutlet weak var addToListContainerViewBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var addedToListPopupLabel: UILabel!
    @IBOutlet weak var addedToListPopup: UIView!
    @IBOutlet weak var dimViewButton: UIButton!
    
    var addToListContainerViewDestinationBottomSpace: CGFloat!
    var containerViewController: AddToListContainerViewController!
    var productId : NSString = ""
    var currentProduct : Product!
    var webViewReady : Bool = false
    var jsonDataReady : Bool = false
    var jsonString : NSString!
    var json : JSON?
    var addToListVisible : Bool = false

    
    override func viewDidLoad() {
        
        self.startPage = "index.html/"
        
        super.viewDidLoad()
        
        self.saveInstanceToAppDelegate()
        
        self.setUpAddToListPopup()
        
        self.setUpAddToListContainer()
        
        self.setupWebView()
        
        self.showDimViewButton()
       
        //query for product information
        self.getProductById()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        setUpNavigationBar()
    }
    
    
    /**
    When the view disappears it hides the progress hud
    
    :param: animated
    */
    override func viewWillDisappear(animated: Bool) {
       Utils.dismissProgressHud()
    }
    
    
    /**
    This method is called by viewDidLoad. It calls MILWLHelper's getProductById method and then shows the progressHud
    */
    private func getProductById(){
        MILWLHelper.getProductById(self.productId, callBack: self.productRetrievalResult)
        Utils.showProgressHud()
    }
    
    func productRetrievalResult(success: Bool, jsonResult: JSON?) {
        if success {
            if let result = jsonResult {
                self.receiveProductDetailJSON(result)
            }
        } else {
            self.failureGettingProductById()
        }
    }
    
    /**
    This method is called by the GetProductByIdDataManager when the onFailure is called by Worklight. It first dismisses the progress hud and then if the view is visible it shows the error alert
    */
    func failureGettingProductById(){
        Utils.dismissProgressHud()
        if (self.isViewLoaded() == true && self.view.window != nil ) { //check if the view is currently visible
            Utils.showServerErrorAlertWithCancel(self, tag: 1) //only show error alert if the view is visible
        }
    }
    
    
    /**
    This method is called by ProductIsAvailableDataManager when the onFailure is called by the Worklight. It first dismisses the progress hud and then if the view is visible it shows the error alert
    */
    func failureGettingProductAvailability(){
         Utils.dismissProgressHud()
        if (self.isViewLoaded() == true && self.view.window != nil) {
            Utils.showServerErrorAlertWithCancel(self, tag: 2)
        }
    }
    
    
    /**
    This method is called when the user clicks a button on the alert view. If the user clicks a button with index 1 then it shows the progress hud and then retries either the getProductById method or the queryProductIsAvailable method. If the butten clicked is index 0 then it pops the view controller to go back to the browseViewController.
    
    :param: alertView
    :param: buttonIndex
    */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(alertView.tag == 1){
            if(buttonIndex == 1){
                Utils.showProgressHud()
                self.getProductById()
            }
            else{
                 self.navigationController?.popViewControllerAnimated(true)
            }
        }
        else if(alertView.tag == 2){
            if(buttonIndex == 1){
                Utils.showProgressHud()
                self.queryProductIsAvailable()
            }
            else{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    
    /**
    This method saves the current instance of ProductDetailViewController to the app delegate's instance variable "productDetailViewController"
    */
    private func saveInstanceToAppDelegate(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.productDetailViewController = self
    }
    
    
    /**
    This method sets up the the navigation bar with various properties
    */
    private func setUpNavigationBar(){
        //customize back arrow
        //set the back button to be just an arrow, nothing in right button space (nil)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationItem.rightBarButtonItem = nil
   
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 22)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    /**
    This method sets up the webview
    */
    private func setupWebView(){
        self.view.bringSubviewToFront(self.webView)
        self.delegate = self
        self.setupWebViewConstraints()
    }
    

    /**
    This method sets up the addToListPopup
    */
    private func setUpAddToListPopup(){
        self.addedToListPopup.alpha = 0
        self.addedToListPopup.layer.cornerRadius = 10
    }
    
    
    /**
    This method sets ups the AddToListContainer
    */
    private func setUpAddToListContainer(){
        
        self.addToListContainerViewDestinationBottomSpace = self.addToListContainerViewBottomSpace.constant
        
        self.addToListContainerViewBottomSpace.constant = -(self.addToListContainerView.frame.size.height + self.tabBarController!.tabBar.bounds.size.height)
        
        self.providesPresentationContextTransitionStyle = true;
        self.definesPresentationContext = true;
    }

    /**
    This method shows the dimViewButton by making it not hidden, changing its alpha and bringing it up to the front
    */
    private func showDimViewButton(){
        self.dimViewButton.alpha = 0.0
        self.dimViewButton.hidden = false
        self.dimViewButton.alpha = 0.6
        
        self.view.bringSubviewToFront(self.dimViewButton)
    }
    
    
    /**
    This method hides the dimViewbutton by changing it to hidden and making its alpha set to 0.0
    */
    private func hideDimViewButton(){
        if (self.addToListVisible == false) {
            self.dimViewButton.hidden = true
        }
    }

    
    /**
    This method is called if the callback changes. If pathComponents[2] is set to "Ready
     then it sets the webViewReady instance variable to true and it then calls the tryToInjectData method. If both the webView and data are ready then it will inject the data.
    
    :param: pathComponents
    */
    func callBackHasChanged(pathComponents: Array<String>) {
        if (pathComponents[2] == "Ready") {
            
            self.webViewReady = true
            
            self.tryToInjectData()
        }
    }
    
    /**
    This method takes care of if the addToList Button was pressed on the hybrid side. It calls the addToListTapped method to show the modal popup of the addToListContainer
    
    :param: pathComponents
    */
    func nativeViewHasChanged(pathComponents: Array<String>) {
        if (pathComponents[2] == "AddToList") {
          self.addToListTapped()
        }
    }
    
    
    /**
    This method first checks if data can be injected by calling the canInjectData method. If this is true, then it calls the injectData method and then hides the dimViewButton
    */
    private func tryToInjectData(){
        if(self.canInjectData() == true){
            self.injectData()
            self.hideDimViewButton()
        }
    }
    
    /**
    This method checks if data can be injected. It does this by checking if the jsonDataReady and webViewReady are both set to true. If it is set to true, then it returns true, else false.
    
    :returns: A Bool representing if data can be injected
    */
    private func canInjectData() -> Bool{
        if(self.jsonDataReady == true && self.webViewReady == true){
            return true
        }
        else{
            return false
        }
    }
    
    
    /**
    This method injects data into the web view by injecting the jsonString instance variable.
    */
    private func injectData(){
        var injectData : String = "injectData(\(self.jsonString))";
        var inject : String = Utils.prepareCodeInjectionString(injectData);
        self.webView.stringByEvaluatingJavaScriptFromString(inject);
        Utils.dismissProgressHud()
    }
    
    
    /**
    This method is called by the GetProductByIdDataManager when it has finished massaging the product detail json. It sets the json instance variable to the json parameter. It then calls parseProduct of JSONParseHelper and sets the currentProduct instance variable to the return value of this method. After it calls the queryProductIsAvailable method to query for product availabilty.
    
    :param: json the massaged product detail json the webview expects
    */
    func receiveProductDetailJSON(json : JSON){
        
        self.json = json

        self.currentProduct = JSONParseHelper.parseProduct(json)

        self.updateTitle()
        
        self.queryProductIsAvailable()
    }
    
    
    /**
    This method updates the title of the navigation bar
    */
    private func updateTitle(){
        if let name = self.currentProduct?.name {
            self.navigationItem.title = name.uppercaseString
        }
    }
    
    
    /**
    This method is called by the receiveProductDetailJSON method. It first calls MILWLHelper's productIsAvailable method. If this method returns false, then this means the user isn't logged in and it will procede to inject data without product availability since getting product availability is a protected call and a user needs to be logged in to make this call.
    */
    func queryProductIsAvailable(){
        if(MILWLHelper.productIsAvailable(self.currentProduct.id, callback: self) != true){
            
            self.jsonString = "\(self.json!)"
            self.jsonDataReady = true
            self.tryToInjectData()
        }
    }
    
    
    /**
    This method is called by the ProductIsAvailableDataManager when it is ready to send the product availability information to the ProductDetailViewController. It will recieve a 1 for In Stock, 0 for out of stock, or a 2 for no information available. When this method receives this information, it adds it to the json instance variable and then updates to the jsonString instance variable and sets the jsonDataReady instance variable to true. After it trys to inject data by calling the tryToInjectData method.
    
    :param: availability 1 for In Stock, 0 for out of stock, or a 2 for no information available
    */
    func recieveProductAvailability(availability : Int){
    
        if(availability == 1){
            self.json!["availability"] = "In Stock"
        }
        else if (availability == 0){
            self.json!["availability"] = "Out of Stock"
        }
        else if (availability == 2){
            self.json!["availability"] = ""
        }
        
        self.jsonString = "\(self.json!)"
    
        self.jsonDataReady = true
        
        self.tryToInjectData()
    }
    
    
    
    /**
    This method is called by the ReadyAppsChallengeHandler when the user authentication has timed out thus not allowing us to do productIsAvailable procedure call to Worklight since this call is protected. Thus, this method injects data to the webview without the product availability.
    */
    func injectWithoutProductAvailability(){
        self.jsonString = "\(self.json!)"
        self.jsonDataReady = true
        self.tryToInjectData()
    }
    
    
    
    /**
    calls the UserAuthHelper's checkIfLoggedIn method, and shows login view if not logged in. If logged in, shows choose list view
    */
    func addToListTapped(){
        var utils: Utils = Utils()
        if (UserAuthHelper.checkIfLoggedIn(self)) {
            self.addToListVisible = true
            self.dimViewButton.hidden = false
            self.view.bringSubviewToFront(self.dimViewButton)
            self.view.bringSubviewToFront(self.addToListContainerView)
            
            UIView.animateWithDuration(0.4, animations: {
                //
                self.dimViewButton.alpha = 0.6
                self.addToListContainerViewBottomSpace.constant = self.addToListContainerViewDestinationBottomSpace
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    
    /**
    dismisses the add to list view from the screen if user touches outside or presses cancel/X button
    */
    func dismissAddToListContainer() {

        UIView.animateWithDuration(0.4, animations: {
            //
            self.dimViewButton.alpha = 0
            self.addToListContainerViewBottomSpace.constant = -(self.addToListContainerView.frame.size.height + self.tabBarController!.tabBar.bounds.size.height)
            self.view.layoutIfNeeded()
            }, completion: { finished in
                if (self.containerViewController.currentSegueIdentifier == "createAList") {
                    self.containerViewController.swapViewControllers()
                }
        })
        self.dimViewButton.hidden = true
        self.view.endEditing(true)
        self.addToListVisible = false
    
    }
    
    /**
    dismiss add to list container if user taps outside of it
    
    :param: sender 
    */
    @IBAction func tappedOutsideOfListContainer(sender: AnyObject) {
        if(self.canInjectData() == true){
            self.dismissAddToListContainer()
        }
    }
    
    
    /**
    added to list popup fade out
    */
    func fadeOutAddedToListPopup() {
        UIView.animateWithDuration(1, animations: {
            //
            self.addedToListPopup.alpha = 0
        })
    }
    
    
    /**
    added to list popup fade in
    */
    func fadeInAddedToListPopup() {
        UIView.animateWithDuration(1, animations: {
            //
            self.addedToListPopup.alpha = 0.95
            }, completion: { finished in
                        })
    }
    

    /**
    function to show grey popup on bottom of screen saying that the item was added to a particular list after tapping that list. includes fade in/out
    
    :param: listName - name of the list the item was added to
    */
    func showPopup(listName: String) {
        // create attributed string
        let localizedString = NSLocalizedString("Product added to \(listName)!", comment: "")
        let string = localizedString as NSString
        var attributedString = NSMutableAttributedString(string: string as String)
 
        //Add attributes to two parts of the string
        attributedString.addAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 14)!,  NSForegroundColorAttributeName: UIColor.whiteColor()], range: string.rangeOfString("Product added to "))
        attributedString.addAttributes([NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 14)!,  NSForegroundColorAttributeName: UIColor.whiteColor()], range: string.rangeOfString("\(listName)!"))
        
        //set label to be attributed string and present popup
        self.addedToListPopupLabel.attributedText = attributedString
        self.fadeInAddedToListPopup()
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("fadeOutAddedToListPopup"), userInfo: nil, repeats: false)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addToListContainer") {
            self.containerViewController = segue.destinationViewController as! AddToListContainerViewController
        }
    }
    
    /**
    This method is called when the tappedBackButton is pressed.
    
    :param: sender
    */
    @IBAction func tappedBackButton(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    }
    
    

}
