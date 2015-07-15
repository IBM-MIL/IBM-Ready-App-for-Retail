/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

import Realm

class List: RLMObject {
    dynamic var name = ""
    dynamic var created = NSDate()
    dynamic var products = RLMArray(objectClassName: Product.className())
    
    /**
    Method to convert Realm object to a more primitive type, useful in transferring data to iOS extensions
    
    :returns: Dictionary of List object
    */
    func encodeToDictionary() ->  Dictionary<String, AnyObject> {
     
        var jsonDictionary = ["name" : self.name] as  Dictionary<String, AnyObject>
        var jsonArray = [Dictionary<String, AnyObject>]()
        
        for (index, product) in enumerate(self.products) {
            var productObject = product as! Product
            jsonArray.append(productObject.encodeToDictionary())
        }
        
        jsonDictionary["products"] = jsonArray
        return jsonDictionary
    }
}
