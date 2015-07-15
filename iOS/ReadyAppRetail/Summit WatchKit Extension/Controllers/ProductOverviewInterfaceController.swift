/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation
import Realm

class ProductOverviewInterfaceController: WKInterfaceController {
    
    // var product: JSON?
    var product: Product?
    var productUrl: String?

    @IBOutlet weak var departmentIcon: WKInterfaceImage!
    @IBOutlet weak var departmentName: WKInterfaceLabel!
    @IBOutlet weak var productName: WKInterfaceLabel!
    
    @IBOutlet weak var imageGroup: WKInterfaceGroup!
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var loadingImageView: WKInterfaceImage!
    
    @IBOutlet weak var currentPriceLabel: WKInterfaceLabel!
    @IBOutlet weak var originalPriceLabel: WKInterfaceLabel!
    
    @IBOutlet weak var star1: WKInterfaceImage!
    @IBOutlet weak var star2: WKInterfaceImage!
    @IBOutlet weak var star3: WKInterfaceImage!
    @IBOutlet weak var star4: WKInterfaceImage!
    @IBOutlet weak var star5: WKInterfaceImage!
    var starArray: [WKInterfaceImage] = []
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        if let p = context as? Product {
            self.product = p
            
            // Set the title of the page
            self.setTitle("Back")
            
            // For use in image fetching thread
            self.productUrl = self.product!.imageUrl as String
            
            self.departmentIcon.setImageNamed(WatchUtils.departmentIcon(self.product!.departmentName as String))
            self.departmentName.setText(self.product!.departmentName as String)
            self.productName.setText(self.product!.name as String)
            
            let price = self.product!.price
            let salePrice = self.product!.salePrice
            
            if (salePrice > 0) {
                self.currentPriceLabel.setText("$\(salePrice)")
                self.originalPriceLabel.setText("Originally $\(price)")
                self.originalPriceLabel.setHidden(false)
            } else {
                self.currentPriceLabel.setText("$\(price)")
            }
            
            // Code to handle star rating; Rating should be at most 5
            starArray = [star1, star2, star3, star4, star5]
            
            if let productRev = self.product!.rev as? String {
                if let productRating = productRev.toInt() {
                    for index in 0..<productRating {
                        starArray[index].setImageNamed("Yellow_Star_Icon")
                    }
                }
            }
            
            if (self.product!.checkedOff) {
                clearAllMenuItems()
                addMenuItemWithItemIcon(WKMenuItemIcon.Add, title: "Add item", action: "doCheckOffItemAction")
            } else {
                clearAllMenuItems()
                addMenuItemWithItemIcon(WKMenuItemIcon.Accept, title: "Mark complete", action: "doCheckOffItemAction")
            }
            
            var dispatchQueue : dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, CUnsignedLong(0))
            dispatch_async(dispatchQueue) { ()
                in
                
                var data : NSData? = NSData(contentsOfURL:
                    NSURL(string: self.productUrl!)!)
                
                if (data != nil) {
                    self.imageView.setImage(UIImage(data: data!))
                    self.imageGroup.setBackgroundColor(UIColor.whiteColor())
                    self.loadingImageView.setHidden(true)
                    self.imageView.setHidden(false)
                } else {
                    println("No image data was returned from the server")
                }
            }
            self.loadingImageView.setImageNamed("Activity")
            self.loadingImageView.startAnimatingWithImagesInRange(NSMakeRange(0, 15), duration: 1.0, repeatCount: 0)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        // Perform Handoff: make product available on iPhone
        self.updateUserActivity(HandoffProductID, userInfo: [HandoffProductIDSubKey : (self.product!.id as String)], webpageURL:nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        // Deactivate handoff
        super.invalidateUserActivity()
        
    }
    
    func doCheckOffItemAction() {
        let id: AnyObject! = self.product!["id"]
        let realm = RLMRealm.defaultRealm()
        
        realm.beginWriteTransaction()
        self.product!.checkedOff = !self.product!.checkedOff
        realm.commitWriteTransaction()
        
        self.popController()
    }
    
}