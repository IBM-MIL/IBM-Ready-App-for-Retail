/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class Product: RLMObject {
   
    dynamic var id : NSString = ""
    dynamic var imageUrl : NSString = ""
    dynamic var price : Double = -1
    dynamic var salePrice : Double = 0
    dynamic var name : NSString = ""
    dynamic var type : NSString = ""
    dynamic var rev : NSString = ""
    dynamic var aisle : Int = 0
    dynamic var departmentName : NSString = ""
    dynamic var departmentId : NSString = ""
    dynamic var proximity : NSString = "1" //far proximity initially
    
    dynamic var checkedOff : Bool = false
    
    /**
    Method to convert Realm object to a more primitive type, useful in transferring data to iOS extensions
    
    :returns: Dictionary of Product data
    */
    func encodeToDictionary() -> Dictionary<String, AnyObject> {
        
        var encodedDictionary = Dictionary<String, AnyObject>()
        encodedDictionary["id"] = self.id
        encodedDictionary["imageUrl"] = self.imageUrl
        encodedDictionary["price"] = self.price
        encodedDictionary["salePrice"] = self.salePrice
        encodedDictionary["name"] = self.name
        encodedDictionary["type"] = self.type
        encodedDictionary["rev"] = self.rev
        encodedDictionary["aisle"] = self.aisle
        encodedDictionary["departmentName"] = self.departmentName
        encodedDictionary["departmentId"] = self.departmentId
        encodedDictionary["checkedOff"] = self.checkedOff
        
        return encodedDictionary
    }
    
    /**
    This method sets the imageUrl of the product. It first checks to see if the passed in parameter has "http" already in it. If it does it means the path is already a full imageUrl. Else if it doesn't have "http" then it calls MILWLHelper's createImageUrl method to create the full imageUrl of the product image.
    
    :param: path 
    */
    func determineImageUrl(path : NSString){
        
        if(path.rangeOfString("http").location != NSNotFound){
            self.imageUrl = path
        }else{
            self.imageUrl = WLProcedureCaller.createImageUrl(path)
        }
    }
    
    
    
}
