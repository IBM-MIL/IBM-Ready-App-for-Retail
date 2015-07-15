/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ItemMetaDataObject: NSObject {
   
    var id : NSString = ""
    var imageUrl : NSString = ""
    var type : NSString = ""
    var rev : NSString = ""
    
    /**
    This method creates the imageURL for the ItemMetaDataObject using the path parameter and calling the milWLHelper getServerURL method
    
    :param: path the path recieved from Worklight
    */
    func determineImageUrl(path : NSString){
        
         self.imageUrl = WLProcedureCaller.createImageUrl(path)
        
    }
    
    
}
