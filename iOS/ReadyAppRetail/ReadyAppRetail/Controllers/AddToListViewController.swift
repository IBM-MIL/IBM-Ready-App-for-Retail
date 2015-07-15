/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class AddToListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /**
    dismiss add to list view if user cancels
    
    :param: sender
    */
    @IBAction func cancelAddToList(sender: AnyObject) {
        var productDetailViewController: ProductDetailViewController = self.parentViewController!.parentViewController as! ProductDetailViewController
        productDetailViewController.dismissAddToListContainer()
    }

    /**
    show create new list view if user taps the plus button
    
    :param: sender 
    */
    @IBAction func createNewList(sender: AnyObject) {
        (self.parentViewController as! AddToListContainerViewController).swapViewControllers()
    }
}
