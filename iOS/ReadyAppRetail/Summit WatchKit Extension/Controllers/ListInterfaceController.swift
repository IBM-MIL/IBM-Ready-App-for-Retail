/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation
import Realm

class ListInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var itemListTable: WKInterfaceTable!
    @IBOutlet weak var addProductsLabel: WKInterfaceLabel!
    
    var list: List!
    var sortedProducts: RLMResults?
    var wormhole: MMWormhole?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        if let l = context as? List {
            self.list = l
        } else {
            self.list = nil
        }
        
        self.wormhole = MMWormhole(applicationGroupIdentifier: GroupDataAccess.sharedInstance.groupAppID, optionalDirectory: nil)
        self.wormhole!.listenForMessageWithIdentifier("refreshProducts", listener: { (messageObject) -> Void in
            self.reloadTable()
        })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.setTitle(self.list.name)
        
        self.reloadTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /**
    Method to parse through json and load data into table
    */
    func reloadTable() {
        
        self.sortedProducts = self.list.products.sortedResultsUsingProperty("checkedOff", ascending: true)
        
        let numRows = Int(sortedProducts!.count > 20 ? 20 : sortedProducts!.count)
        self.itemListTable.setNumberOfRows(numRows, withRowType: "ItemRow")
        
        for (var i = 0 ; i < numRows ; i++) {
            if let row = self.itemListTable.rowControllerAtIndex(i) as? ItemRow {
                
                let product : Product? = sortedProducts!.objectAtIndex(UInt(i)) as? Product
                
                let deptName : String = product!.departmentName as String
                let itmName : String = product!.name as String
                
                row.departmentLabel.setText(deptName)
                row.itemNameLabel.setText(itmName)
                
                if (product!.checkedOff) {
                    row.itemRowGroup.setBackgroundColor(UIColor.clearColor())
                    row.departmentLabel.setTextColor(UIColor.lightGrayColor())
                    row.itemNameLabel.setTextColor(UIColor.lightGrayColor())
                    row.departmentIcon.setImageNamed("Mark_Complete_List_Icon")
                } else {
                    let depIcon : String = WatchUtils.departmentIcon(product!.departmentName as String)
                    row.departmentIcon.setImageNamed(depIcon)
                }
            }
        }
        
        if (numRows <= 0) {
            self.addProductsLabel.setHidden(false)
        } else {
            self.addProductsLabel.setHidden(true)
        }
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "productSegue" {
            var productData : AnyObject = self.sortedProducts!.objectAtIndex(UInt(rowIndex))
            return productData
        }
        
        return nil
    }

}