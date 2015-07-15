/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

public protocol Serializable {
    
    func jsonRepresentation() -> JSON
    
}


public protocol ParentDataRequest: Serializable {
    
    var identifier: String { get }
    
}