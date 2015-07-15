/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class AddToListContainerViewController: UIViewController {
    
    var currentSegueIdentifier: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentSegueIdentifier = "chooseAList"
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "chooseAList") { //show choose a list view controller
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(self.childViewControllers[0] as! UIViewController, toViewController: segue.destinationViewController as! UIViewController, flip: false)
                
            }
            else {
                //If no, add that view to child view controllers.
                self.addChildViewController(segue.destinationViewController as! UIViewController)
                (segue.destinationViewController as! UIViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                self.view.addSubview((segue.destinationViewController as! UIViewController).view)
                segue.destinationViewController.didMoveToParentViewController(self)
            }
        }
        
        if (segue.identifier == "createAList") { //show create a list view controller
            self.swapFromViewController(self.childViewControllers[0] as! UIViewController, toViewController: segue.destinationViewController as! UIViewController, flip: true)
            
        }
    }
    
    
    /**
    Performs the transition from one ViewController to the other. Has option to allow for flip animation.
    
    :param: fromViewController
    :param: toViewController
    :param: flip               
    */
    func swapFromViewController(fromViewController: UIViewController, toViewController: UIViewController, flip: Bool)
    {
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        var width: CGFloat = self.view.frame.size.width;
        var height: CGFloat = self.view.frame.size.height;
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        if flip{
            toViewController.view.frame = CGRectMake(width, 0, width, height);
            self.transitionFromViewController(fromViewController,
                toViewController: toViewController,
                duration: 0.4,
                options: UIViewAnimationOptions.TransitionNone,
                animations: {
                    fromViewController.view.frame = CGRectMake(0 - width, 0, width, height)
                    toViewController.view.frame = CGRectMake(0, 0, width, height)
                },
                completion: { finished in
                    fromViewController.removeFromParentViewController()
                    toViewController.didMoveToParentViewController(self)
            })
            
        } else {
            toViewController.view.frame = CGRectMake(0-width, 0, width, height);
            self.transitionFromViewController(fromViewController,
                toViewController: toViewController,
                duration: 0.4,
                options: UIViewAnimationOptions.TransitionNone,
                animations: {
                    fromViewController.view.frame = CGRectMake(0 + width, 0, width, height)
                    toViewController.view.frame = CGRectMake(0, 0, width, height)
                },
                completion: { finished in
                    fromViewController.removeFromParentViewController()
                    toViewController.didMoveToParentViewController(self)
            })
            
        }
    }
    
    /**
    function which animates/swaps view controllers shown between creating and choosing a list
    */
    func swapViewControllers() {
        if (self.currentSegueIdentifier == "chooseAList") {
            self.currentSegueIdentifier = "createAList"
        }
        else if (self.currentSegueIdentifier == "createAList"){
            self.currentSegueIdentifier = "chooseAList"
        }
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }
    
    

}
