/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

public struct ProductDataRequest: ParentDataRequest, Serializable {
    
    public let productId: String
    public let identifier = WatchKitProductDetails
    
    init(productId: String) {
        self.productId = productId
    }
    
    public func jsonRepresentation() -> JSON {
        return JSON(["productId" : productId])
    }
    
}

public struct ListsDataRequest: ParentDataRequest, Serializable {
    
    public let identifier = WatchKitGetLists
    
    public func jsonRepresentation() -> JSON {
        return [:] // no extra data to send
    }
    
}