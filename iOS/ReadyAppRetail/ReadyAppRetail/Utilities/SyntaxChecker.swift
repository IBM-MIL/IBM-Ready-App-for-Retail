/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


import Foundation
import UIKit

public class SyntaxChecker {
    
    
    /**
    This method check if the username in the usernameTextField is of correct format.
    
    :returns: Bool - Whether username is of valid format or not
    */
    class public func checkUserName(username : NSString) -> Bool{

        if(username.length != 0){
            var fullNameRegex : NSString = "[A-Z0-9a-z_]+"
            var fullNameTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
            var result : Bool = fullNameTest.evaluateWithObject(username)
            if(result == false){
                var alert = UIAlertView()
                alert.title = NSLocalizedString("Invalid Username", comment:"")
                alert.message = NSLocalizedString("Please enter only valid characters", comment: "")
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
                return false
            }
            else{
                return true
            }
            
        }
        else{
            var alert = UIAlertView()
            alert.title = NSLocalizedString("Invalid Username", comment: "")
            alert.message =  NSLocalizedString("You must enter a username", comment: "")
            alert.addButtonWithTitle( NSLocalizedString("OK", comment: ""))
            alert.show()
            return false
        }
    }
    
    
    /**
    This method check if the username in the passwordTextField is of correct format.
    
    :returns: Bool - Whether username is of valid format or not
    */
    class public func checkPassword(password : NSString) -> Bool{
        
        if(password.length > 6){
            var passWordRegex : NSString = "[A-Z0-9a-z_@!&%$#*?]+"
            var passWordTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
            var result : Bool = passWordTest.evaluateWithObject(password)
            if(result == false){
                var alert = UIAlertView()
                alert.title =  NSLocalizedString("Invalid Password", comment: "")
                alert.message =  NSLocalizedString("Please Try Again", comment: "")
                alert.addButtonWithTitle( NSLocalizedString("OK", comment: ""))
                alert.show()
                return false
            }
            else{
                return true
            }
        }
        else{
            var alert = UIAlertView()
            alert.title =  NSLocalizedString("Invalid Password", comment: "")
            alert.message =  NSLocalizedString("Please Try Again",comment: "")
            alert.addButtonWithTitle( NSLocalizedString("OK", comment: ""))
            alert.show()
            return false
        }
    }
    
    
    /**
    This method checks to see if the listName parameter is valid. It first checks to see if the length of the list name is greater than 0, else it returns false. If the length of the list name is greater than 0 then it checks if the first character of the list begins either with a alpha character or a numberic character, else it returns false and shows an alert message to the user.
    
    :param: listName
    
    :returns:
    */
    class public func checkListName(listName : String) -> Bool{
      
        var firstChar = Array(listName)[0]
    
        var firstCharString : String = "\(firstChar)"
        
        if(count(listName) > 0){
            if(isNumber(firstCharString) || isAlpha(firstCharString)){
                return true
            }
            else{
                var alert = UIAlertView()
                alert.title =  NSLocalizedString("Invalid List name", comment: "")
                alert.message =  NSLocalizedString("A list must begin with a letter or number",comment: "")
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
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
    
    :param: string
    
    :returns:
    */
    class private func isNumber(string : String) -> Bool{
        
        var numberRegex : NSString = "\\d{1}"
        var numberTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        var result : Bool = numberTest.evaluateWithObject(string)
        
        if(result){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    /**
    This method checks if a string is only alpha characters. returns true - only alpha, false - not only alpha
    
    :param: string
    
    :returns:
    */
    class private func isAlpha(string : String) -> Bool{
            var alphaRegex : NSString = "[A-Za-z]+"
            var alphaTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", alphaRegex)
            var result : Bool = alphaTest.evaluateWithObject(string)
            if(result == false){
                return false
            }
            else{
                return true
            }
    }
}