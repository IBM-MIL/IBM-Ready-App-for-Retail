/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class XtifyHelper: NSObject {
   
    
    /**
    This method sends a location update to Xtify to be the exact gps coordinates as a predefined Xtify location, thus triggering a push notification on the user's device.
    */
    class func updateNearSummitStore(){
        var cllocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.267, longitude: -97.743)
        XLappMgr.get().updateLocationWithCoordinate(cllocation, andAlt: Float(229.225098), andAccuracy: Float(4000.000000))
    }
    
    
    /**
    This method sends a location update to Xtify to be a random gps coordinate to reset the user's location
    */
    class func resetLocationForDemo(){
        var cllocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.001, longitude: -85.71)
        XLappMgr.get().updateLocationWithCoordinate(cllocation, andAlt: Float(229.225098), andAccuracy: Float(4000.000000))
    }
    
    
    
}
