/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


import Foundation
import UIKit

public class SyntaxChecker {
    
    
    /**
    This method checks if the email in the emailTextField is of correct format.
    
    - returns: Bool - Whether email is of valid format or not
    */
    class public func checkEmail(email: NSString) -> Bool{
        
        let emailRegex : NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let result : Bool = emailTest.evaluateWithObject(email.lowercaseString)
        if(result == false){
            //var altMessage = UIAlertController(title: "Warning", message: "This is Alert Message", preferredStyle: UIAlertControllerStyle.Alert)
            let alert = UIAlertView()
            
            alert.title = "Invalid Email"
            alert.message = "Please enter a valid email"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        return result
    }
    
    /**
    This method checks if the name in the fullnameTextField is of correct format.
    
    - returns: Bool - Whether name is of valid format or not
    */
    class public func checkFullName(fullname: NSString)->Bool{
        
        if(fullname.length != 0){
            let fullNameRegex : NSString = "[A-Za-z.' -]+"
            let fullNameTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
            let result : Bool = fullNameTest.evaluateWithObject(fullname)
            if(result == false){
                let alert = UIAlertView()
                alert.title = "Invalid Name"
                alert.message = "Please enter only valid characters"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
            else{
                return true
                
            }
            
        }
        else{
            let alert = UIAlertView()
            alert.title = "Invalid Name"
            alert.message = "You must enter a name "
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }
    }
    
    
    /**
    This method check if the username in the usernameTextField is of correct format.
    
    - returns: Bool - Whether username is of valid format or not
    */
    class public func checkUserName(username : NSString) -> Bool{

        if(username.length != 0){
            let fullNameRegex : NSString = "[A-Z0-9a-z_]+"
            let fullNameTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
            let result : Bool = fullNameTest.evaluateWithObject(username)
            if(result == false){
                let alert = UIAlertView()
                alert.title = "Invalid Username"
                alert.message = "Please enter only valid characters"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
            else{
                return true
            }
            
        }
        else{
            let alert = UIAlertView()
            alert.title = "Invalid Username"
            alert.message = "You must enter a username "
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }
    }
    
    
    /**
    This method check if the username in the passwordTextField is of correct format.
    
    - returns: Bool - Whether username is of valid format or not
    */
    class public func checkPassword(password : NSString) -> Bool{
        
        if(password.length > 6){
            let passWordRegex : NSString = "[A-Z0-9a-z_@!&%$#*?]+"
            let passWordTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
            let result : Bool = passWordTest.evaluateWithObject(password)
            if(result == false){
                let alert = UIAlertView()
                alert.title = "Invalid Password"
                alert.message = "Please Try Again"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
            else{
                return true
            }
        }
        else{
            let alert = UIAlertView()
            alert.title = "Invalid Password"
            alert.message = "Please Try Again"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }
    }
    
    
    /**
    This method checks if the zip code entered in the zipCodeTextField is of the correct format, 5 numbers
    
    - returns: Bool - Indicating whether the zip code entered is of the correct format
    */
    class public func checkZipCode(zipcode: NSString)->Bool{
        
        let fullNameRegex : NSString = "\\d{5}"
        let fullNameTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        let result : Bool = fullNameTest.evaluateWithObject(zipcode)
        
        if(result){
            return true;
        }
        else{
            let alert = UIAlertView()
            alert.title = "Invalid Zip Code"
            alert.message = "Please enter a valid zipcode"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false;
        }
    }
    
    
    /**
    This method checks if the bio entered in the bioTextField is less than 30 characters
    
    - returns: Bool - Indicating whether the bio entered is less than 30 characters
    */
    class public func checkBio(bio : NSString)->Bool{
        if(bio.length < 30){
            return true
        }
        else{
            let alert = UIAlertView()
            alert.title = "Bio Too Long"
            alert.message = "Bio must be less than 30 characters"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
            
        }
    }
    
    
    /**
    This method checks if the website entered in the websiteTextField is less than 30 characters
    
    - returns: Bool - Indicating whether the website entered is less than 30 characters
    */
    class public func checkWebsite(website: NSString)->Bool{
        if(website.length < 30){
            return true
        }
        else{
            let alert = UIAlertView()
            alert.title = "Website Too Long"
            alert.message = "Website must be less than 30 characters"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }
    }
    
    
    
    /**
    This method checks to see if the listName parameter is valid. It first checks to see if the length of the list name is greater than 0, else it returns false. If the length of the list name is greater than 0 then it checks if the first character of the list begins either with a alpha character or a numberic character, else it returns false and shows an alert message to the user.
    
    - parameter listName:
    
    - returns:
    */
    class public func checkListName(listName : String) -> Bool{
      
        let firstChar = Array(listName.characters)[0]
    
        let firstCharString : String = "\(firstChar)"
        
        if(listName.characters.count > 0){
            if(isNumber(firstCharString) || isAlpha(firstCharString)){
                return true
            }
            else{
                let alert = UIAlertView()
                alert.title = "Invalid List name"
                alert.message = "A list must begin with a letter or number"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
        }
        else{
            return false
        }
    }
    
    
    /**
    This method checks if the string parameter is a number. returns true - a number, false - not a number.
    
    - parameter string:
    
    - returns:
    */
    class private func isNumber(string : String) -> Bool{
        
        let numberRegex : NSString = "\\d{1}"
        let numberTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        let result : Bool = numberTest.evaluateWithObject(string)
        
        if(result){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    /**
    This method checks if a string is only alpha characters. returns true - only alpha, false - not only alpha
    
    - parameter string:
    
    - returns:
    */
    class private func isAlpha(string : String) -> Bool{
            let alphaRegex : NSString = "[A-Za-z]+"
            let alphaTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", alphaRegex)
            let result : Bool = alphaTest.evaluateWithObject(string)
            if(result == false){
                return false
            }
            else{
                return true
            }
    }
}