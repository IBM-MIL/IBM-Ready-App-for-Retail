/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import Realm

class BeaconManager: NSObject, CLLocationManagerDelegate {
    var locationManager : CLLocationManager?
    var allBeacons: Array<String> = Array<String>()
    var beaconRegion : CLBeaconRegion?
    var closestBeaconID: String!
    var departmentsCount: Int = 0
    var productClose: Product = Product()
    var listItemsTableViewController: ListItemsTableViewController!
    var canRefreshListItemsTableViewController: Bool = false
    var lastSortedByID : String!
    
    //order not important, contains departmentId:beacon assigned to it
    var departments : [String: String] = [String:String]()

    
    //just to order the departments when assigning to beacons. contains departments only
    var departmentsArray: [String]!


    /**
    override the init method to set up locationManager, delegate, beaconRegion, and present popup to request location usage from user
    
    :returns:
    */
    override init() {
        super.init()
        //set beacon manager delegate
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
        //set beacon region
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "MIL_Lab")
        
        
        self.beaconRegion!.notifyOnEntry = true
        self.beaconRegion!.notifyOnExit = true
        
    }
    
    /**
    function to receive departments and set departmentsArray
    
    :param: departmentArray -- array to be passed in
    */
    func receiveDepartments(departmentArray : Array<String>){
        
        self.departmentsArray = departmentArray
        
        for department in departmentArray {
            
            
            self.departments[department] = ""
            
            
            
        }
        
        
    }
    
    
    /**
    begin beacon detection monitoring for the given beaconRegion
    */
    func startBeaconDetection() {
        // - Start monitoring
        self.locationManager!.startMonitoringForRegion(self.beaconRegion)
    }
    
    /**
    start ranging beacons once it started monitoring
    
    :param: manager
    :param: region
    */
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        NSLog("Scanning for beacons in region --> %@...", region.identifier)
        self.locationManager!.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    
    /**
    func to be called upon entering given region (with beacons)
    
    :param: manager
    :param: region
    */
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        // - Start ranging beacons
        NSLog("You entered the region --> %@ - starting scan for beacons", region.identifier)
        //self.delegate!.didEnterRegion(region as CLBeaconRegion)
        self.locationManager!.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        
        
        XtifyHelper.updateNearSummitStore()
    }
    
    
    /**
    func to be called upon exiting given region
    
    :param: manager
    :param: region
    */
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        // - Stop ranging beacons
        NSLog("You exited the region --> %@ - stopping scan for beacons", region)
        //self.delegate!.didExitRegion(region as CLBeaconRegion)
        self.locationManager!.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    
    /**
    func to be called upon a failure in monitoring beacons
    
    :param: manager
    :param: region
    :param: error
    */
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        NSLog("Error monitoring \(error)")
    }
    
    /**
    func to be called approx once per second while ranging beacons. assigns newly discovered beacons to a department in the order given to departmentsArray
    
    :param: manager
    :param: beacons
    :param: region
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown } //filter out unknown beacons
         //let knownBeacons = beacons.filter{$0.proximity == CLProximity.Immediate}
        //if beacons are found at all, continue
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as! CLBeacon //save closest Beacon for sorting later
            var newBeaconID = closestBeacon.major.stringValue + closestBeacon.minor.stringValue
            
            if (newBeaconID != self.closestBeaconID) { //if new closest beacon
                self.closestBeaconID = newBeaconID
            }
            
            //if new beacon discovered, add it to a department.
            //NOTE: in the real world you wouldn't dynamically assign beacons to a department. Beacons would typically be hard coded to a department already.
            if (self.allBeacons.count < knownBeacons.count) {
                self.addBeaconsToDepartments(self.closestBeaconID)
            }
            
            
            //Check to make sure the closestBeaconId is different from the last beacon id we sorted the list by. Also check to make sure the list items tableview controller is visible, no point in sorting the list when the table view controller isn't visible. Also check to make sure the beacon we are about to sort by is of imediate proximity.
            if (self.lastSortedByID != self.closestBeaconID && self.canRefreshListItemsTableViewController == true && (closestBeacon.proximity == CLProximity.Immediate)) {
                
                self.lastSortedByID = self.closestBeaconID
                
                self.sortListByLocation(self.listItemsTableViewController.list.products, list: self.listItemsTableViewController.list)
            }
            
        }
        //no beacons detected
        else {
            NSLog("No beacons are nearby")
        }
    }
    
    
    /**
    func containing the algorithm to assign beacons to departments if they haven't been assigned yet. assigns departments in order they are received from Worklight (in departmentsArray)
    
    :param: closeBeaconID  -- the id of the closest beacon
    */
    func addBeaconsToDepartments(closeBeaconID: String!){
        if contains(self.allBeacons, closeBeaconID) { //if beacon has already been assigned, don't do anything!
            return
        }
        
        if (self.departments[self.departmentsArray[self.departmentsCount]] == "") { //if department not been assigned a beacon yet
            self.allBeacons.append(closeBeaconID) //make note that we've assigned this beacon now
            self.departments[self.departmentsArray[self.departmentsCount]] = closeBeaconID
            println("Beacon \(closeBeaconID) assigned to Department \(self.departmentsArray[self.departmentsCount])")
            self.departmentsCount++ //assign next department next time
        }
        
    }
    
    
    
    /**
    func to sort an array of products in a given list, and return a List object in the new order based on closest beacon/department
    
    :param: dataArray -- data array of products passed in from ListItemsTableViewController
    :param: list      -- list these products belong to
    
    :returns: same list with new order based on proximity
    */
    func sortListByLocation(dataArray: RLMArray!, list: List) {
        var refresh: Bool = false  //only reorder list if at least one department has been detected as closest
        for (var i = 0; i < Int(dataArray.count); i++){
            self.productClose = dataArray.objectAtIndex(UInt(i)) as! Product
                if (self.departments[self.productClose.departmentId as String] == self.closestBeaconID) {
                    //if product's department is also the closest beacon/department, set closer (0) proximity
                    RealmHelper.addProductToListWithProximity(list, product: self.productClose, proximityDesired: "0", index: UInt(i)) //rearrange product in Realm
                    self.listItemsTableViewController.departmentSortedBy = self.productClose.departmentName as String //update which department list is being sorted by
                    //println("Moved \(self.productClose.departmentName) to top of list!")
                    refresh = true
                } else {
                    //product is not closeby, so make proximity farther (1)
                  RealmHelper.addProductToListWithProximity(list, product: self.productClose, proximityDesired: "1", index: UInt(i))
            }
            
        }
        if (refresh == true){ //only reorder list if at least one department has been detected as closest
            self.listItemsTableViewController.dataArray = list.products.sortedResultsUsingProperty("proximity", ascending: true)
            self.listItemsTableViewController.reorderList()
        }
        
    }
    
    
    
    /**
    returns the string for proximity of a beacon
    
    :param: proximity
    
    :returns: 
    */
    class func proximityAsString(proximity: CLProximity) -> String {
        switch proximity {
        case CLProximity.Far:
            return "Far"
            
        case CLProximity.Near:
            return "Near"
            
        case CLProximity.Immediate:
            return "Immediate"
            
        case CLProximity.Unknown:
            return "Unknown"
        }
    }
    
    
    
    
    
}
