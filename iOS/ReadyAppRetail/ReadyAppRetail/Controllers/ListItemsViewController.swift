/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ListItemsViewController: UIViewController {
    
    var list: List!
    
    @IBOutlet var sortedListPopup: UIView!
    
    @IBOutlet weak var sortedListPopupLabel: UILabel!

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stylize popup and get ready to be presented
        self.setupPopup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //set the back button to be just an arrow, nothing in right button space (nil)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = list.name.uppercaseString
    }
    
    /**
    set initial alpha to 0 so popup is not visible initially. also corner radius to make it have circular corners
    */
    func setupPopup() {
        self.sortedListPopup.alpha = 0
        self.sortedListPopup.layer.cornerRadius = 10
    }
    
    
    /**
    sorted list popup fade out
    */
    func fadeOutSortedListPopup() {
        UIView.animateWithDuration(1, animations: {
            //
            self.sortedListPopup.alpha = 0
        })
    }
    
    
    /**
    sorted list popup fade in
    */
    func fadeInSortedListPopup() {
        UIView.animateWithDuration(1, animations: {
            //
            self.sortedListPopup.alpha = 0.95
            }, completion: { finished in
        })
    }
    
    
    /**
    func to show the toast/popup when a list is reordered based on closest department
    
    :param: departmentName -- closest department
    */
    func showPopup(departmentName: String) {
        self.view.bringSubviewToFront(self.sortedListPopup)
        // create attributed string
        let localizedString = NSLocalizedString("Welcome to \(departmentName)!", comment: "")
        let string = localizedString as NSString
        var attributedString = NSMutableAttributedString(string: string as String)
        
        //Add attributes to two parts of the string
        attributedString.addAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 14)!,  NSForegroundColorAttributeName: UIColor.whiteColor()], range: string.rangeOfString("Welcome to "))
        attributedString.addAttributes([NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 14)!,  NSForegroundColorAttributeName: UIColor.whiteColor()], range: string.rangeOfString("\(departmentName)!"))
        
        //set label to be attributed string and present popup
        self.sortedListPopupLabel.attributedText = attributedString
        self.fadeInSortedListPopup()
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("fadeOutSortedListPopup"), userInfo: nil, repeats: false)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "containerForListItems") {
            var listItemsTableViewController: ListItemsTableViewController = segue.destinationViewController as! ListItemsTableViewController
            listItemsTableViewController.list = self.list
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /**
    called when user taps back, will pop to previous view controller
    
    :param: sender
    */
    @IBAction func tappedBackButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


}
