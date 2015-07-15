/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

class WatchUtils {
    class func departmentIcon(departmentName: String) -> String{
        switch departmentName {
            case "Camping Essentials":
                return "Tent_Icon"
            case "Men's Boots":
                return "Shoe_Icon"
            case "Winter Sports":
                return "Snowflake_Icon"
            default:
                return ""
        }
    }
}