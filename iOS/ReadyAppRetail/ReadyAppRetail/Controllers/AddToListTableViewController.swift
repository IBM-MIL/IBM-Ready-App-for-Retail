/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class AddToListTableViewController: UITableViewController {

    var dataArray = List.allObjects().sortedResultsUsingProperty("name", ascending: true)
    var notificationToken: RLMNotificationToken?
    
    var wormhole: MMWormhole?
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.wormhole = MMWormhole(applicationGroupIdentifier: GroupDataAccess.sharedInstance.groupAppID, optionalDirectory: nil)
            
            // Set realm notification block
            notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
                self.tableView.reloadData()
            }
            
            ListTableViewControllerHelper.registerNibFile(self.tableView)
            
            tableView.reloadData()
            self.tableView.separatorColor = UIColor.clearColor();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    /**
    This method determines the number of rows in a section
    
    :param: tableView
    :param: section
    
    :returns: 
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataArray.count > 0) {
           return Int(dataArray.count + dataArray.count - 1); // -1 to remove the extra spacecell at the end of the list, otherwise for every list, there is a spacecell that is after the list
        }
        else {
            return 0
        }
        
    }

    /**
    This method generates the cell for row at indexPath
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 1){ //to check if cell is odd
            return ListTableViewControllerHelper.createSpaceCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        else {
            let list = dataArray[UInt(indexPath.row/2)] as! List   //indexPath.row/2 - 1 to handle mismatch between the indexPath and dataArray indexing
            return ListTableViewControllerHelper.createListCell(list, tableView: tableView, cellForRowAtIndexPath: indexPath)
            
        }
    }
    
    /**
    This method determines the height for the row at index path
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->CGFloat
    {
        if (indexPath.row % 2 == 1){ //spaceCell
            return 3
        } else {
            return 65 //ListCell
        }
        
    }
    
    /**
    This method determines the action that is triggered when a row is tapped. If the user touches a list, then it checks to see if that product is already in the list. If it is, then it doesn't add the product to the list and presents the user with a warning, else it adds the product to the list
    
    :param: tableView
    :param: indexPath
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row % 2 == 1){ //to check if cell is odd, if it is then its a space cell
            
        }
        else {
            let object = dataArray[UInt(indexPath.row/2)] as! List   //indexPath.row/2 - 1 to handle mismatch between the indexPath and dataArray indexing
            
             var productDetailViewController: ProductDetailViewController = self.parentViewController!.parentViewController!.parentViewController as! ProductDetailViewController
            var product = productDetailViewController.currentProduct
            
            if(RealmHelper.addProductToList(object, product: product) == true){
                productDetailViewController.dismissAddToListContainer()
                productDetailViewController.showPopup(object.name)
                                self.wormhole!.passMessageObject("refreshProducts", identifier: "refreshProducts")
            }
            else{
               RealmHelper.productAlreadyExistsInList()
                self.tableView.reloadData()
            }
            
        }
    }
    

    

}
