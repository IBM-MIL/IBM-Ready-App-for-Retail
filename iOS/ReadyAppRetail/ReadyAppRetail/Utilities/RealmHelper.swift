/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class RealmHelper: NSObject {
    
    /**
    This method adds the realmObject parameter to the default realm
    
    :param: realmObject the realmObject to be added to realm
    */
   class func addObjectToRealm(realmObject : RLMObject){
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.addObject(realmObject)
        realm.commitWriteTransaction()
    }
    
    /**
    This method adds the product parameter to the list parameter if the product isn't already in the list. It returns true if it was a success or false if it was a failure
    
    :param: list    the list the product is to be added too
    :param: product the product to be added to the list
    */
    class func addProductToList(list : List, product : Product) -> Bool{
        if(self.doesListHaveProductAlready(product, list: list) == false){
         let realm = RLMRealm.defaultRealm()
         realm.beginWriteTransaction()
         list.products.addObject(product)
         realm.commitWriteTransaction()
            return true
        }
        else{
            return false
        }
    }
    
    
    /**
    This method checks to see if a list already has a product in it. If it does it returns true, else it returns false
    
    :param: product
    :param: list
    
    :returns:
    */
    class func doesListHaveProductAlready(product : Product, list : List) -> Bool{
        
        var products = list.products
        var numberOfProducts : Int = Int(products.count)
        
        for( var i = 0; i < numberOfProducts; i++){
            
            var prod = products[UInt(i)] as! Product
            
            if(prod.id == product.id){
                return true
            }
        }
        
        return false
    }
    
    /**
    This method shows the user an error alert stating that the product the user tried to add is already in the list.
    */
    class func productAlreadyExistsInList(){
        var alert = UIAlertView()
        alert.title = "Product Aleady In List"
        alert.message = "Please choose a different list"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    /**
    This method adds a product to a list that has the same name as the listName parameter.
    
    :param: product  the product to be added to the list
    :param: listName the name of the list that the product should be added to
    */
    class func addProductToListWithName(product : Product, listName : String){
        
        let list = getListWithName(listName)
        
        addProductToList(list, product: product)
    }
    
    
    
    /**
    func to replace product in a list with a copy of itself but with updated proximity (0 for closer, 1 for farther away)
    
    :param: list             list belonging to
    :param: product          product to be swapped
    :param: proximityDesired desired new proximity
    :param: index            index where to replace the product
    */
    class func addProductToListWithProximity(list : List, product : Product, proximityDesired: String, index: UInt){
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        product.proximity = proximityDesired
        list.products.replaceObjectAtIndex(index, withObject: product)
        //list.products.addObject(product)
        realm.commitWriteTransaction()
    }
    
    /**
    This method creates a realm in the default realm. It first checks to see if a list of that name already exists. If it doesn't it creates a list with the name parameter.
    
    :param: name the name of the list to be created
    
    :returns: a boolean to represent whether the list was created successfully or not based on whether there already was a list with that name
    */
    class func createList(name : NSString) -> Bool{
        if(doesListAlreadyExist(name) == false){
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            var list : List = List()
            list.name = name as String
            list.created = NSDate()
            realm.addObject(list)
            realm.commitWriteTransaction()
            return true
        }
        return false
    }

    
    /**
    This method checks to see if there is already a list with a name already in the default realm
    
    :param: listName the name to check if there is already a list with this name
    
    :returns: a Bool representing whether there is a list with this name already
    */
    class func doesListAlreadyExist(listName : NSString) -> Bool{
        var list = List.objectsWhere("name = \"\(listName)\"")
        
        if(list.count == 1){
            return true
        }
        else{
           return false
        }
    }
    
    
    /**
    This method gets the Realm List with the listName parameter string
    
    :param: listName the listName to query Realm for
    
    :returns: the Realm List with the listName parameter string as its name
    */
    class func getListWithName(listName : String) -> List{
        var list = List.objectsWhere("name = \"\(listName)\"")

        return list[0] as! List
    }
    
    /**
    This method calculates the total price amount of all the items in the list parameter. It then returns this total as a Double
    
    :param: list the total price amount of the items of this list will be calculated
    
    :returns: the total price amount of the irms in the list
    */
    class func getTotalPriceAmountOfList(list : List) -> Double{
        
        var products = list.products
        
        var total : Double = 0.00
        
        for product in products{
            if((product as! Product).salePrice > 0){
                total = total + (product as! Product).salePrice
            
            }
            else{
                if((product as! Product).price > 0){
                    total = total + (product as! Product).price
                }
            }
        }
        
        return total
    }

    /**
    This method gets the photo to be displayed for the list parameter
    
    :param: list the list that this method will return a photo for
    
    :returns: an imageURL for the photo of the list
    */
    class func getListPhoto(list : List) -> NSString{
        
        var products = list.products as RLMArray
        
        if(products.count > 0){
            var product = products[products.count - 1] as! Product
            return product.imageUrl
        }
        else{
            return ""
        }
        
    }
    
    // MARK: WatchKit Helper Methods
    
    /**
    Method to convert list of realm objects to a JSON object
    
    :param: lists array of Lists
    :param: listcount number of objects encoded from front of the list
    
    :returns: SwiftyJson Object
    */
    class func encodeListsToJson(lists: RLMResults, listCount: Int) -> JSON {
        
        var jsonDictionary = Dictionary<String, AnyObject>()
        
        var arrayJson = [Dictionary<String, AnyObject>]()
        for (index, list) in enumerate(lists) {
            
            // Once we have encoded enough objects, stop encoding
            if index == listCount {
                break
            }
            
            var listObject: List = list as! List
            println("date: \(listObject.created)")
            arrayJson.append(listObject.encodeToDictionary())
        }
        
        jsonDictionary["results"] = arrayJson
        return JSON(jsonDictionary)
    }
    
}
