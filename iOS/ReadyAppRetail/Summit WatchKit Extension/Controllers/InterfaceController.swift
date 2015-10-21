/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var listLabel: WKInterfaceLabel!
    @IBOutlet weak var storeLabel: WKInterfaceLabel!
    @IBOutlet weak var salesLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        print("WatchKit App is open")
        let font = UIFont.systemFontOfSize(12)
        let attirbuteData = [NSFontAttributeName : font]
        
        var labelText = NSAttributedString(string: "View Lists", attributes: attirbuteData)
        self.listLabel.setAttributedText(labelText)
        labelText = NSAttributedString(string: "Locate Store", attributes: attirbuteData)
        self.storeLabel.setAttributedText(labelText)
        labelText = NSAttributedString(string: "Current Sales", attributes: attirbuteData)
        self.salesLabel.setAttributedText(labelText)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func viewLists() {
        
        self.pushControllerWithName("ListOverviewInterface", context: nil)
    }
    
    @IBAction func requestData() {
        let request = ProductDataRequest(productId: "0000000002")
        ParentAppDataManager.sharedInstance.execute(request, retry: true, result: { (resultDictionary) -> () in
          print("REsults: \(resultDictionary)")
        })
    }

}
