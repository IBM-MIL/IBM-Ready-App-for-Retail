/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class ListItemsTableViewController: UITableViewController {

    var list : List!

    var dataArray : RLMResults!
    var numberOfItemsInSection : Int = 0
    
    var notificationToken: RLMNotificationToken?
    var productDetailViewController : ProductDetailViewController!
    

    var departmentSortedBy: String!
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataArray = list.products.sortedResultsUsingProperty("departmentId", ascending: true)
        self.setNumberOfItemsInSection()
        self.tableView.reloadData()
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        
        ListTableViewControllerHelper.registerSpaceCellNibFile(self.tableView)
        
        self.tableView.separatorColor = UIColor.clearColor();
    }
    
    
    /**
    This method is used to determine how many items should be in a section. This method is needed to correctly display the "total cell" at the end of the list.
    */
   func setNumberOfItemsInSection(){
        if(list.products.count > 0){
            var number = Int(self.list.products.count + self.list.products.count)
            if(number % 2 == 1){ //odd
                self.numberOfItemsInSection = number + 2
            }
            else{
                self.numberOfItemsInSection = number + 1
            }
        }
        else if(list.products.count == 0){
            self.numberOfItemsInSection = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //set the back button to be just an arrow, nothing in right button space (nil)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = list.name
        self.setupBeaconManagerForReordering() //setup beaconmanager
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
    
        //reload the tableview to deselect any selected items after popping back here
       self.tableView.reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.beaconManager!.canRefreshListItemsTableViewController = false  //tell beaconmanager to stop refreshing
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection
    }
    
    
    /**
    This method is needed to determine the height in respect to the current indexPath being generated.
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->CGFloat
    {
        if(indexPath.row % 2 == 1){ //spaceCell
            return 3
        } else if(indexPath.row == self.numberOfItemsInSection){ //Total cell
            return 65
        }
        else {
            return 65 //ListCell
        }
        
    }

    /**
    This method is used to determine what cell is generated for the specific indexPathj
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == self.numberOfItemsInSection - 1){ //display total cell since this is the last cell of the table
            return createTotalCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        else if (indexPath.row % 2 == 1){ //to check if cell is odd, display spaceCell
            return createSpaceCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        else {//display the ListItemCell
            return createListItemCell(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    /**
    This method is called in the cellForRowAtIndexPath method. It is used to create and setUp the TotalCell
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    private func createTotalCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! TotalTableViewCell
        
        let moneySignLocalizedString = NSLocalizedString("$", comment: "")
        
        let listTotal = RealmHelper.getTotalPriceAmountOfList(self.list)
        var listTotalString : String!
        
        if(listTotal == 0.0){
            listTotalString = "0.00"
        }
        else{
            listTotalString = "\(listTotal)"
        }
        
        cell.totalPriceLabel.text = "\(moneySignLocalizedString)\(listTotalString)"
        cell.userInteractionEnabled = false
        return cell
    }
    
    /**
    This method is called in the cellForRowAtIndexPath method. It is used to create and setUp the SpaceCell by calling ListTableViewControllerHelper's createSpaceCell method. 
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    private func createSpaceCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return ListTableViewControllerHelper.createSpaceCell(self.tableView, cellForRowAtIndexPath: indexPath)
    }
    
    /**
    This method is called in the cellForRowAtIndexPath method. It is used to create and setUp the ListItemCell
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    private func createListItemCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell", forIndexPath: indexPath) as! ListItemTableViewCell
        let product = dataArray[UInt(indexPath.row/2)] as! Product   //indexPath.row/2 - 1 to handle mismatch between the indexPath and dataArray indexing
        
        cell.itemNameLabel.text = product.name as String
        if (product.salePrice == 0) {
            cell.itemPriceLabel.text = "$\(product.price)"
            
            // create attributed string
            let moneySignLocalizedString = NSLocalizedString("$", comment: "")
            let string : NSString = "\(moneySignLocalizedString)\(product.price)"
            var attributedString = NSMutableAttributedString(string: string as String)
            
            // create font descriptor for bold and italic font
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            
            //Create attributes for two parts of the string
            let firstAttributes = [NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 18)!, NSForegroundColorAttributeName: Utils.UIColorFromHex(0xBE9B00, alpha: 1)]
            
            var firstString : NSString = "\(moneySignLocalizedString)\(product.price)"
            
            //Add attributes to two parts of the string
            attributedString.addAttributes(firstAttributes, range: string.rangeOfString(firstString as String))
            
            cell.itemPriceLabel.attributedText = attributedString
        }
        else {
        // create attributed string
        let moneySignLocalizedString = NSLocalizedString("$", comment: "")
            let string : NSString = "\(moneySignLocalizedString)\(product.price)   \(moneySignLocalizedString)\(product.salePrice)"
        var attributedString = NSMutableAttributedString(string: string as String)
        
        // create font descriptor for bold and italic font
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        
        //Create attributes for two parts of the string
            //d1d3d4
        let firstAttributes = [NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 18)!, NSForegroundColorAttributeName: Utils.UIColorFromHex(0xd1d3d4, alpha: 1)]
        let secondAttributes = [NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 18)!, NSForegroundColorAttributeName: Utils.UIColorFromHex(0xBE9B00, alpha: 1)]
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        
        var firstString : String = "\(moneySignLocalizedString)\(product.price)"
        var secondString : String = "   \(moneySignLocalizedString)\(product.salePrice)"
        
        //Add attributes to two parts of the string
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString(firstString))
        attributedString.addAttributes(strikeThroughAttributes, range: string.rangeOfString(firstString))
        attributedString.addAttributes(secondAttributes, range: string.rangeOfString(secondString))
        
        cell.itemPriceLabel.attributedText = attributedString
        
        }
            
        cell.itemDepartmentLabel.text = product.departmentName as String
        let url = NSURL(string: product.imageUrl as String)
        cell.itemImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholderproduct"))

        
        return cell
    }
    
    
    /**
    This method is used to determine what happens when you click on a tableRow. In this case it pushes to the productDetail and determines what product row was tapped.
    
    :param: tableView
    :param: indexPath
    */
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showProductDetail", sender: self)
         var product : Product = dataArray[UInt(indexPath.row/2)] as! Product
         self.productDetailViewController.productId = product.id
        
    }
    
    /**
    This method sets up the beacon manager for reordering
    */
    func setupBeaconManagerForReordering() {
        //access BeaconManager
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.dataArray = list.products.sortedResultsUsingProperty("departmentId", ascending: true) //first make sure items are categorized by department (not in order of closest yet)
        appDelegate.beaconManager!.listItemsTableViewController = self
        appDelegate.beaconManager!.canRefreshListItemsTableViewController = true //ready to refresh because current list is being shown
    }
    
    
    /**
    func to be called everytime list needs reordering, also presents popup saying that list has been reordered
    */
    func reorderList() {
        self.setNumberOfItemsInSection()
        self.tableView.reloadData()
        var listItemsViewController: ListItemsViewController = self.parentViewController! as! ListItemsViewController
        listItemsViewController.showPopup(self.departmentSortedBy)
    }
    
    
    /**
    called when user taps back, will pop to previous view controller
    
    :param: sender 
    */
    @IBAction func tappedBackButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showProductDetail"){
            self.productDetailViewController = segue.destinationViewController as! ProductDetailViewController
        }
    }
}
