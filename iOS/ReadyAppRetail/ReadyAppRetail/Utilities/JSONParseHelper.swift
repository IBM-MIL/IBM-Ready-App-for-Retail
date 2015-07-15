/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class JSONParseHelper: NSObject {

    
    /**
    This method takes the response data from Worklight and creates and returns a Swifty JSON Object
    
    :param: response the response data from Worklight
    
    :returns: The swift JSON objects created
    */
    class func createJSONObject(response: WLResponse!) -> JSON{
        
        let responseJson = response.getResponseJson()
        
        if(responseJson != nil){
            if let resultString = responseJson["result"] as? NSString{
                let dataFromString = resultString.dataUsingEncoding(NSUTF8StringEncoding)
                return JSON(data: dataFromString!);
                
                
            }
            else{
                let resultString = "bad json"
                let dataFromString = resultString.dataUsingEncoding(NSUTF8StringEncoding)
                return JSON(data: dataFromString!);

                
            }
            
        }
        else{
            let resultString = "bad json"
            let dataFromString = resultString.dataUsingEncoding(NSUTF8StringEncoding)
            return JSON(data: dataFromString!);
        }
        
    }
    
    /**
    This method is called by the HomeViewMetadataManager class. It calls the parseJSON method to get respective ItemMetaDataObject arrays based on the key it provides to this method. It then creates a dictionary with keys that correspeond to the ItemMetaDataObject arrays.
    
    :param: json the json received from the Worklight call.
    
    :returns: a dictionary with keys, featured, recommended, and all that correspond to ItemMetaDataObject arrays for those respective collectionviews.
    */
    class func parseHomeViewMetadataJSON(response: WLResponse!) -> Dictionary<String, [ItemMetaDataObject]> {
        
        var json = createJSONObject(response)
    
        var parsedDictionary = Dictionary<String, [ItemMetaDataObject]>()
        var featuredItemsArray : [ItemMetaDataObject] = parseHomeJSON(json, key: "featured")
        var recommendedItemsArray : [ItemMetaDataObject] = parseHomeJSON(json, key: "recommended")
        var allItemsArray : [ItemMetaDataObject] = parseHomeJSON(json, key: "all")
        
        parsedDictionary["featured"] = featuredItemsArray
        parsedDictionary["recommended"] = recommendedItemsArray
        parsedDictionary["all"] = allItemsArray
        
        return parsedDictionary
    }
    

    /**
    This method parses the json received from a Worklight call. It uses the SwiftyJSON framework to help with the parsing of the json. After it is finished parsing the json it returns an array of ItemMetaDataObject objects to be used as data for the featured carousel collection view of the browse view controller.
    
    :param: json the swifyy json object created by the method that called this method
    
    :returns: an array of ItemMetaDataObject objects parsed from the received json
    */
    class func parseHomeJSON(json: JSON, key : NSString) -> [ItemMetaDataObject]{
        var itemsArray = [ItemMetaDataObject]()
        
        if let jSONArray = json["\(key)"].array {
            for item in jSONArray{
                itemsArray.append(self.createItemMetaDataObject(item))
            }
        }
        
        return itemsArray
    }
    
    /**
    This method creates an ItemMetaDataObject based on the json parameter it recieves. This method is called from the parseJSON method.
    
    :param: item a parse json item from the parseJSON method.
    
    :returns: an ItemMetaDataObject created from the item json parameter
    */
    class private func createItemMetaDataObject(item : JSON) -> ItemMetaDataObject{
        var itemMetaDataObject = ItemMetaDataObject()
        
        if let id  = item["_id"].string{
            itemMetaDataObject.id = id
        }
        
        if let rev = item["rev"].string{
            itemMetaDataObject.rev = rev
        }
        
        if let type = item["type"].string {
            itemMetaDataObject.type = type
        }
        
        if let imageUrl = item["imageUrl"].string {
            itemMetaDataObject.determineImageUrl(imageUrl)
        }
        
        return itemMetaDataObject
    }
    
    
    
    /**
    This method is used to massage the data received from Worklight to prepare it for the format of json that the hybrid view is expecting
    
    :param: response the response from Worklight
    
    :returns: the massaged json that the hybrid view is expecting
    */
    class func massageProductDetailJSON(response: WLResponse!) -> JSON{
        
        //parse departmentName
        var json = createJSONObject(response)
        
        if let departmentName = json["departmentObj"]["title"].string {
            json["location"] = JSON(departmentName)
        }
        
        //parse imageUrl
        var path : NSString!
        
        if let imagePath = json["imageUrl"].string {
            path = imagePath
            var imageUrl = WLProcedureCaller.createImageUrl(path)
            json["imageUrl"] = JSON(imageUrl)
            
        }
        
        
        //parse price
        var currencySymbol = NSLocalizedString("$", comment: "Currency Symbol, for example $")
        
        if let priceRaw = json["priceRaw"].double {
            var price = "\(currencySymbol)\(priceRaw)"
            json["price"] = JSON(price)
        }
        
        //parse salePrice
        if let salePriceRaw = json["salePriceRaw"].double {
            
            var salePrice = "\(currencySymbol)\(salePriceRaw)"
            json["salePrice"] = JSON(salePrice)
        }

        //parse colorOptions
        if let colorOptionsArray = json["colorOptions"].array {
            var numberOfColorOptions = colorOptionsArray.count
            
            for(var i : Int = 0; i<numberOfColorOptions; i++){
                
                if let path = json["colorOptions"][i]["url"].string{
                    var imageUrl = WLProcedureCaller.createImageUrl(path)
                    json["colorOptions"][i]["url"] = JSON(imageUrl)
                }
            }
            
            json["option"]["name"] = JSON("Size")
        }
        
        return json
    
    }
    
    
    /**
    This method parses the json that represents the default lists received from Worklight. It first calls the createJSON object to create a swifty json object, it then loops through and parses each list in the json by calling the parseList method.
    
    :param: response the response json received from Worklight
    */
    class func parseDefaultListJSON(response: WLResponse!){
        var json = createJSONObject(response)
        
        if let listArray = json.array {
            for listJSON in listArray{
                parseList(listJSON)
            }
        }
        
    }
    
    
    /**
    This method parses a swifty json object that represents a list that has products. It first parses the name of the list and adds a list with this name to Realm by calling the createList method of RealmHelper. It then goes through each product of the list and calls the parseProduct method to create a realm product object from the product swifty json. It then adds this realm product object to the Realm list object.
    
    :param: listJSON the json representing the list being parsed.
    */
    class private func parseList(listJSON : JSON){
        
        var list : List = List()
        
        if let name = listJSON["name"].string{
            
            if(RealmHelper.createList(name) == true){
            
                var list = RealmHelper.getListWithName(name)
            
                if let productsArray = listJSON["products"].array{
                    for productJSON in productsArray{
                    
                        var product = parseProduct(productJSON)
                        RealmHelper.addProductToList(list, product: product)
                    }
                }
                
            }
        }
    }
    
    
    /**
    This method takes a switfy json object that represents a product and parses this json into a Realm product object
    
    :param: productJSON the swifty json that represents a product
    
    :returns: the Realm product object parsed from the switfy json
    */
     class func parseProduct(productJSON : JSON) -> Product{
        
        var product : Product = Product()
    
        if let id  = productJSON["_id"].string{
            product.id = id
        }
        
        if let name = productJSON["name"].string{
            product.name = name
        }
        
        if let rev = productJSON["rating"].int {
            product.rev = String(rev)
        }
        
        if let imageUrl = productJSON["imageUrl"].string {
            product.determineImageUrl(imageUrl)
        }
        
        if let price = productJSON["priceRaw"].double {
            product.price = price
        }
        
        if let salePrice = productJSON["salePriceRaw"].double {
            product.salePrice = salePrice
        }
        
        if let departmentName = productJSON["departmentObj"]["title"].string {
            product.departmentName = departmentName
        }
        
        if let departmentId = productJSON["departmentObj"]["_id"].string {
            product.departmentId = departmentId
        }
        
        
       return product
        
    }
    
    
    /**
    This method parses the response json received from Worklight and returns an array of department id's
    
    :param: response the response json received from Worklight
    
    :returns: an array of department id's parsed from the response json
    */
    class func parseAllDepartments(response: WLResponse!)->Array<String> {
        
        var json = createJSONObject(response)
        
        var departmentArray : Array<String> = Array<String>()
        
        if let departmentCount = json.array?.count {
            
            for(var i = 0; i<departmentCount; i++){
                
                if let departmentId = json[i]["_id"].string{
                    departmentArray.append(departmentId)
                }
            }

        }
        
        return departmentArray
    }
    
    
    /**
    This method parses the response json received from Worklight and returns a Bool representing if a product is available or not
    
    :param: response the response json received
    
    :returns: a Bool representing if a product is available or not
    */
    class func parseAvailabilityJSON(response: WLResponse!) -> Int{
    
        let responseJson = response.getResponseJson() as Dictionary
        
        //0 false, 1 true
        if let resultString = responseJson["result"]?.integerValue {
           return resultString
        }
        else{
            return 2 //if there is no information about availability 
        }
    }
    
    
    
    /**
    This method takes in response Json receieved from the "submitAuthentication" Worklight procedure call when the call succeeded and parses the userId from the response json and then returns this userId as a string
    
    :param: response
    
    :returns:
    */
    class func parseUserId(response : WLResponse) -> String{
        
        let responseJson = response.getResponseJson() as NSDictionary
        
        
        if let userId = responseJson["result"] as? String{
            
            return userId
            
        }
        else{
            return NSLocalizedString("userId", comment:"")
            
        }
        
    }
    
    
    
    /**
    This method parses the response JSON recieved from the "submitAuthentication" Worklight procedure call when the call failed and then parses this response to figure out why the call failed. It returns a string representing an error message. 
    
    :param: response
    
    :returns:
    */
    class func parseLoginFailureResponse(response : WLResponse!) -> String{
        
        response.getResponseJson()
        
        let responseJson = response.getResponseJson()
        
        if(responseJson != nil){
        
            if let onAuthRequired = responseJson["onAuthRequired"] as? NSDictionary {
                if let errorMessage = onAuthRequired["errorMessage"] as? NSString {
                    return errorMessage as String
                }
                else{
                    return NSLocalizedString("Server error", comment:"")
                }
            }
            else{
                return NSLocalizedString("Server error", comment:"")
            }
        }
        else{
           return NSLocalizedString("Server error", comment:"") 
        }
  
    }
        
    
    
}
