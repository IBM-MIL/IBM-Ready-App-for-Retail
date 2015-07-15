/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class CreateListInAddToListHierarchyViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var listNameTextField: UITextField!
    var containerViewController: AddToListContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameTextField.delegate = self
        
        //make cursor color summit green
        self.listNameTextField.tintColor = Utils.UIColorFromHex(0x005448, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.listNameTextField.becomeFirstResponder() //show keyboard
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    When "Done"/Return key on keyboard is pressed, save new list item to Realm and dismiss modal
    
    :param: textField
    
    :returns:
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        //save new list to realm
       return createAndAddProductToList()
    }
    
    
    /**
    This method is used to create a list. It is called when the return key of the keyboard is pressed.
    
    :returns: A Bool representing if the creation of the list was a success or not.
    */
    func createAndAddProductToList() -> Bool{
        var syntaxChecker : SyntaxChecker = SyntaxChecker()
        
        if(SyntaxChecker.checkListName(self.listNameTextField.text)){
            
            if(RealmHelper.createList(self.listNameTextField.text)){
                //dismiss VC
                self.listNameTextField.resignFirstResponder()
                
                self.addProductToListWithNameHelper(self.listNameTextField.text)
                dismissAddToListViewController()
                return true
            }
            else{
                self.listAlreadyExists()
                return false
            }
        }
        else{
            return false
        }
    }
    
    
    /**
    This method is a helper method that gets reference to the productDetailViewController to get the current Product the user is looking at and then calls RealmHelper's addProductToListWithName method to add the product to the list
    
    :param: listName the list the product should be added too.
    */
    private func addProductToListWithNameHelper(listName : String){
        
        let productDetailViewController: ProductDetailViewController = self.parentViewController!.parentViewController as! ProductDetailViewController
        var product = productDetailViewController.currentProduct
        
        RealmHelper.addProductToListWithName(product, listName: listName)
        
        self.showAddToListPopUp(listName)
    }
    
    
    /**
    This method gets reference to the current productDetailViewController and then calls the productDetailViewController's dimissAddToListContainer method
    */
    private func dismissAddToListViewController(){
        
       let productDetailViewController: ProductDetailViewController = self.parentViewController!.parentViewController as! ProductDetailViewController
        
        productDetailViewController.dismissAddToListContainer()
        
    }
    
    
    /**
    This method gets reference to the current productDetailViewController and then calls the productDetailViewController's showPopup method.
    
    :param: listName the listName to display in the popup
    */
    private func showAddToListPopUp(listName : String){
        
        let productDetailViewController: ProductDetailViewController = self.parentViewController!.parentViewController as! ProductDetailViewController

        productDetailViewController.showPopup(listName)
    }
    
    /**
    This method is used to show an alert if a list already exists.
    */
    func listAlreadyExists(){
        var alert = UIAlertView()
        alert.title = "List Aleady Exists"
        alert.message = "Please try a different name"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    /**
    Minimizes keyboard and dismiss modal if X button is pressed (cancel)
    
    :param: sender
    */
    @IBAction func dismissCreateListView(sender: AnyObject) {
        //dismiss VC
        self.listNameTextField.resignFirstResponder()
        (self.parentViewController as! AddToListContainerViewController).swapViewControllers()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
