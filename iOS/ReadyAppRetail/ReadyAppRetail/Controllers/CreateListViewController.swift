/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class CreateListViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var listNameTextField: UITextField!
    var containerViewController: AddToListContainerViewController!
    
    var wormhole: MMWormhole?

    override func viewDidLoad() {
        super.viewDidLoad()
        listNameTextField.delegate = self
        
        //make cursor color summit green
        self.listNameTextField.tintColor = Utils.UIColorFromHex(0x005448, alpha: 1)
        
        self.wormhole = MMWormhole(applicationGroupIdentifier: GroupDataAccess.sharedInstance.groupAppID, optionalDirectory: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.listNameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    When "Done"/Return key on keyboard is pressed, save new list item to Realm and dismiss modal only if the list name the user has entered is a valid list name using SyntaxChecker's checkListName method.
    
    :param: textField
    
    :returns:
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        return createList()
    }
    
    
    /**
    This method is used to create a list. It is called when the return key of the keyboard is pressed.
    
    :returns: A Bool representing if the creation of the list was a success or not.
    */
    func createList() -> Bool{
        
        //Check if the list name starts with letter or number
        if(SyntaxChecker.checkListName(self.listNameTextField.text)){
            
            //create a list in realm, this checks if a list in realm with this name already exists
            if(RealmHelper.createList(self.listNameTextField.text)){
                //dismiss VC
                self.listNameTextField.resignFirstResponder()
                self.dismissViewControllerAnimated(true, completion: nil)
                
                // Alert wormhole
                self.wormhole!.passMessageObject("refreshLists", identifier: "refreshLists")
                
                return true
            }
            else{//If a list with this name already exists show alert
                self.listAlreadyExists()
                return false
            }
        }
        else{
            return false
        }
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
        self.dismissViewControllerAnimated(true, completion: nil)

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
