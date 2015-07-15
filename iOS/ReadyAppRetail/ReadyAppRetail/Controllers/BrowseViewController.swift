/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class BrowseViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var featuredContainerView: UIView!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var recommendedContainerView: UIView!
    @IBOutlet weak var shopAllLabel: UILabel!
    @IBOutlet weak var shopAllContainerView: UIView!
    
    var dataArray = []
    var featuredCarouselCollectionViewController : CarouselCollectionViewController!
    var recommendedHorizontalPagedCollectionViewController : HorizontalPagedCollectionViewController!
    var shopAllHorizontalPagedCollectionViewController : HorizontalPagedCollectionViewController!
    var productDetailViewController : ProductDetailViewController!
    var logoImageView : UIImageView!
    
    @IBOutlet weak var scrollViewContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.setUpSectionLabels()
       self.getHomeViewMetadata()
       self.prepareLogoForNavigationBar()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.hideLogoInNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.showLogoInNavigationBar()
    }
    
    /**
    This method creates a logoImageView to be placed in the top left corner of the navigation bar
    */
    private func prepareLogoForNavigationBar(){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        let image: UIImage = UIImage(named: "summit-logo_large")!
        self.logoImageView = UIImageView(image: image)
        self.logoImageView.frame = CGRectMake(14, 4, 25, 25)
    }
    
    /**
    This method shows the logo in the top left corner of the navigation bar
    */
    private func showLogoInNavigationBar(){
        self.logoImageView.alpha = 1.0
        self.navigationController?.navigationBar.addSubview(self.logoImageView)
    }
    
    /**
    This method hides the logo in the top left corner of the navigation bar
    */
    private func hideLogoInNavigationBar(){
        UIView.animateWithDuration(0.3, animations: { self.view.layoutIfNeeded()
            self.logoImageView.alpha = 0.0
            },  completion: { finished in
                 self.logoImageView.removeFromSuperview()
               
        })
    }
    
    /**
    func to allow user interaction with tab bar (after progresshud has finished loading)
    */
    func allowTapsOnTabBar(){
        self.view.userInteractionEnabled = true
        var tabVC : TabBarViewController = self.parentViewController!.parentViewController as! TabBarViewController
        tabVC.tabBar.userInteractionEnabled = true
    }
    
    /**
    func to disable user interaction with tab bar while progresshud is loading
    */
    func disableTapsOnTabBar(){
        self.view.userInteractionEnabled = false
        var tabVC : TabBarViewController = self.parentViewController!.parentViewController as! TabBarViewController
        tabVC.tabBar.userInteractionEnabled = false
    }
    

    /**
    This method calls MILWLHelpers getHomeViewMetadata method
    */
    func getHomeViewMetadata(){
        Utils.showProgressHud()
        self.disableTapsOnTabBar()
         MILWLHelper.getHomeViewMetadata(self)
    }

    /**
    This method is called from the HomeViewMetadataManager. It is called when the HomeViewMetadataManager has recieved data back from Worklight.
    
    :param: parsedDictionary a dictionary with keys "featured", "recommended", and "all" for the respective collectionviews
    */
    func refreshCollectionViews(parsedDictionary : Dictionary<String, [ItemMetaDataObject]>){
        Utils.dismissProgressHud()
        self.allowTapsOnTabBar()
        var featuredDataArray = parsedDictionary["featured"]!
        self.featuredCarouselCollectionViewController.refresh(featuredDataArray)

        var recommendedDataArray = parsedDictionary["recommended"]!
        self.recommendedHorizontalPagedCollectionViewController.refresh(recommendedDataArray)
        
        var allDataArray = parsedDictionary["all"]!
        self.shopAllHorizontalPagedCollectionViewController.refresh(allDataArray)
        
        self.getAllDepartments()
    }
    
 
    
    /**
    This method calls MLWLHelper's getAllDepartments method
    */
    private func getAllDepartments(){
         MILWLHelper.getAllDepartments(self)
    }
    
    
    /**
    This method is called from the HomeViewMetadataManager when onFailure is called from Worklight. This is most likely due to a server connection error. This method thus dismisses the progressHud and then shows a server error alert
    */
    func failureGettingHomeViewMetaData(){
        Utils.dismissProgressHud()
        self.allowTapsOnTabBar()
        Utils.showServerErrorAlert(self, tag: 1)
    }
    
    
    /**
    This method is called from the GetDefaultListDataManager when onFailure is called from Worklight. This is most likely due to a server connection error. This method thus dismisses the progressHud and then shows a server error alert
    */
    func failureGettingAllDepartments(){
        Utils.dismissProgressHud()
        self.allowTapsOnTabBar()
        Utils.showServerErrorAlert(self, tag: 2)
    }
    
    
    /**
    This method is called when the user presses the "Retry" button on the server error alert. If the alert has a tag of 1 then the user is responding to a server error alert with respect to getting the home view data, else if the alert has a tag of 2 then the user is responding to a server error alert with respect to getting the default lists. For either tags, the progress hud is shown and the getHomeViewMetadata or getAllDepartments methods are respectively called.
    
    :param: alertView
    :param: buttonIndex
    */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(alertView.tag == 1){
            Utils.showProgressHud()
            self.getHomeViewMetadata()
        }
        else if(alertView.tag == 2){
            Utils.showProgressHud()
            self.disableTapsOnTabBar()
            self.getAllDepartments()
        }
    }
    
    
    /**
    This method is invoked by GetDefaultListDataManager when it recieves data from Worklight
    
    :param: departmentArray an array of Department Id's recieved from Worklight
    */
    func receiveDepartments(departmentArray : Array<String>){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.beaconManager = BeaconManager()
        appDelegate.beaconManager?.receiveDepartments(departmentArray)
        appDelegate.beaconManager!.startBeaconDetection()
    }
    
    /**
    This method calls the scrollViewContentViewHeight() method when the view appears
    
    :param: animated
    */
    override func viewDidAppear(animated: Bool) {
       self.updateScrollViewContentViewHeight()
        self.navigationItem.title = NSLocalizedString("HOME", comment:"")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 22)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "OpenSans", size: 10)!]
        appearance.setTitleTextAttributes(attributes, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    This method updates the scrollViewContentViewHeight in the viewDidAppear method. This is needed because the height constraint assigned to the scrollViewContentView in storyboard is invalid and doesn't conform to the actual vertical space its subviews take up. If we did not update this constraint then the scrollViewContentViewHeight would be too long vertically
    */
    func updateScrollViewContentViewHeight(){
        //calculate how much verticle space the scrollViewContentView's subviews take up
        var newScrollViewContentViewHeight = featuredContainerView.frame.size.height + recommendedLabel.frame.size.height + recommendedContainerView.frame.size.height + shopAllLabel.frame.size.height + shopAllContainerView.frame.size.height
        
        newScrollViewContentViewHeight = newScrollViewContentViewHeight + 16 //add arbitrary amount of padding
        
        self.scrollViewContentViewHeight.constant = newScrollViewContentViewHeight //assign constraint constant newly calculated valud
    }
    
    /**
    This method sets the recommended and shopAll Labels with Localized Strings
    */
    func setUpSectionLabels(){
       recommendedLabel.text =  NSLocalizedString("Recommended", comment: "A word for suggesting things that would be of interest to a person")
       shopAllLabel.text = NSLocalizedString("Shop All", comment: "Shop All")
    }
    
    
    /**
    This method is called by the HorizontalPagedViewController. It is passed the productId of the item tapped. It then performs a segue to the ProductDetailViewController.
    
    :param: productId the product id of the product tapped. 
    */
    func showProductDetail(productId : NSString){
        
        self.performSegueWithIdentifier("showProductDetail", sender: self)
        self.productDetailViewController.productId = productId
    }
    
    // MARK: - Navigation

    /**
    This method is called right before the embeded segues are called for the 3 container subviews. It checks to see what the segue indentifier is then sets up the destinationViewController's dataArray by passing in the data queried for
    
    :param: segue  The segue about to be performed
    :param: sender
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "recommended"){
            self.recommendedHorizontalPagedCollectionViewController = segue.destinationViewController as! HorizontalPagedCollectionViewController
        }
        if(segue.identifier == "shopall"){
            self.shopAllHorizontalPagedCollectionViewController = segue.destinationViewController as! HorizontalPagedCollectionViewController
        }
        if(segue.identifier == "featured"){
            self.featuredCarouselCollectionViewController = segue.destinationViewController as! CarouselCollectionViewController
        }
        if(segue.identifier == "showProductDetail"){
            self.productDetailViewController = segue.destinationViewController as! ProductDetailViewController
        }
        
    }


}
