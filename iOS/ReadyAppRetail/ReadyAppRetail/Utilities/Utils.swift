/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

/**
*  Utility class primarily for formatting data to be sent to a hyrbrid view.
*/
class Utils {
    
    /**
    This method creates a short angular script to alter data in a hybrid view
    
    :param: functionCall the function to be called in the javascript with arguments included in the string
    
    :returns: a clean script to inject into the javascript
    */
    class func prepareCodeInjectionString(functionCall: String) -> String {
        return "var scope = angular.element(document.getElementById('scope')).scope(); scope." + functionCall + ";" 
    }
    
    
    /**
    function to produce UIColor from hex values
    
    :param: rgbValue
    :param: alpha
    
    :returns: UIColor
    */
    class func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    /**
    This method returns the green summit color
    
    :returns: the green summit UIColor
    */
    class func SummitColor()->UIColor{
        
        var hexColor = UInt32(0x005448)
        
        return UIColorFromHex(hexColor, alpha: 1.0)
    }
    
    
    /**
    This method shows a progress hud using SVProgressHUD
    */
    class func showProgressHud(){
        SVProgressHUD.setForegroundColor(SummitColor())
        //SVProgressHUD.setBackgroundColor(UIColor.lightGrayColor())
        SVProgressHUD.show()
    
    }
    
    /**
    This method dismisses the progress hud (SVProgressHUD)
    */
    class func dismissProgressHud(){
        SVProgressHUD.dismiss()
    }
    
    
    /**
    This method shows a server error alert
    
    :param: delegate
    :param: tag
    */
    class func showServerErrorAlert(delegate : UIViewController, tag : Int){
        var alert = UIAlertView()
        alert.delegate = delegate
        alert.tag = tag
        alert.title = NSLocalizedString("Can't Connect To Server", comment:"")
        alert.addButtonWithTitle("Retry")
        alert.show()
    }
    
    
    /**
    This method shows a server error alert with a cancel button option on the alert
    
    :param: delegate
    :param: tag      
    */
    class func showServerErrorAlertWithCancel(delegate : UIViewController, tag : Int){
        var alert = UIAlertView()
        alert.delegate = delegate
        alert.tag = tag
        alert.title = NSLocalizedString("Can't Connect To Server", comment:"")
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Retry")
        alert.show()
    }
    
    
    /**
    This method reads from info.plist to find out of the app is in development mode or not. This is needed to disable MQA
    
    :returns: whether the app is in development mode or not
    */
    class func isDevelopment() -> Bool{
        
        var configurationPath = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        
        if((configurationPath) != nil) {
            var configuration = NSDictionary(contentsOfFile: configurationPath!)!
            
            if let isDevelopment = configuration["isDevelopment"] as? NSString{
                
           
                if(isDevelopment == "true"){
                    return true
                }
                else{
                    return false
                }
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    

    
}