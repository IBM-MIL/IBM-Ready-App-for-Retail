/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserAuthHelper.checkIfLoggedIn(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationItem.title = NSLocalizedString("MY LISTS", comment:"")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Oswald-Regular", size: 22)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listTableViewSegue") {
            
        }
    }


}
