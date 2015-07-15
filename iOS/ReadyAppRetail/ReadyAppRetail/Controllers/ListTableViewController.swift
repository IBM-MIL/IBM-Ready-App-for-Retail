/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class ListTableViewController: UITableViewController {
    
    var dataArray: RLMResults?
    var toListItemsSegueDestinationViewController : ListItemsViewController!
    var notificationToken: RLMNotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       ListTableViewControllerHelper.registerNibFile(self.tableView)
       
        tableView.reloadData()
        self.tableView.separatorColor = UIColor.clearColor();
        
        if (RLMRealm.defaultRealm() != nil) {
            self.dataArray = List.allObjects().sortedResultsUsingProperty("name", ascending: true)
        }
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    If no data, still show "create list" cell. If data, return correct number of cells (add dataArray.count + dataArray.count because for each data element there is a blank cell as well. Add 1 to take into account the "create list" cell)
    
    :param: tableView
    :param: section
    
    :returns:
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let d = self.dataArray {
            if (d.count == 0) {
                return 1
            }
            else {
                return Int(d.count + d.count + 1);
            }
        }
        return 0
    }

    /**
    If first cell, just show "create list" cell. If an odd cell/indexPath, show blank cell (space every other cell). If any other indexPath, cell should be a ListTableView cell and contain data.
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
           return ListTableViewControllerHelper.createCreateNewListCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        else if (indexPath.row % 2 == 1){ //to check if cell is odd
            return ListTableViewControllerHelper.createSpaceCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        else {
            if let d = self.dataArray {
                let list = d[UInt(indexPath.row/2) - 1] as! List   //indexPath.row/2 - 1 to handle mismatch between the indexPath and dataArray indexing
                return ListTableViewControllerHelper.createListCell(list, tableView: tableView, cellForRowAtIndexPath: indexPath)
            }
        }
        return ListTableViewControllerHelper.createCreateNewListCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    /**
    This method is used to determine the height for the specific indexPath being generated
    
    :param: tableView
    :param: indexPath
    
    :returns:
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->CGFloat
    {
        if (indexPath.row == 0) { //create list cell
            return 65
        } else if (indexPath.row % 2 == 1){ //spaceCell
            return 3
        } else {
            return 65 //ListCell
        }
    }
    
    
    /**
    This method determines the action to be taken when a cell at indexPath has been tapped
    
    :param: tableView
    :param: indexPath 
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row % 2 == 1){ //to check if cell is odd
          
        }
        else {
            if let d = self.dataArray {
                let list = d[UInt(indexPath.row/2) - 1] as! List
                self.performSegueWithIdentifier("toListItems", sender: self)
                self.toListItemsSegueDestinationViewController.list = list //send to the listItemsViewController what list was tapped
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toListItems"){
            self.toListItemsSegueDestinationViewController = segue.destinationViewController as! ListItemsViewController
        }
        
        if (segue.identifier == "createList") {
            
            if (UserAuthHelper.checkIfLoggedIn(self)) {
                //user is logged in
            }
        }
        
    }
    
    


}
