/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

//Project Specific Colors
extension UIColor {
    class func summitMainColor() -> UIColor{return UIColor(hex:"129552")}
    
    class func summitSecondaryColor() -> UIColor{return UIColor(hex:"B5C34A")}
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        var hexString = ""
                
        if hex.hasPrefix("#") {
            let nsHex = hex as NSString
            hexString = nsHex.substringFromIndex(1)
            
        } else {
            hexString = hex
        }
        
        let scanner = NSScanner(string: hexString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            switch (count(hexString)) {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue = CGFloat(hexValue & 0x00F)              / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue = CGFloat(hexValue & 0x0000FF)           / 255.0
            default:
                print("Invalid HEX string, number of characters after '#' should be either 3, 6")
            }
        } else {
            println("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    convenience init?(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat = 1.0){
        let cmykColorSpace = CGColorSpaceCreateDeviceCMYK()
        let colors = [cyan, magenta, yellow, black, alpha] // CMYK+Alpha
        let cgColor = CGColorCreate(cmykColorSpace, colors)
        self.init(CGColor: cgColor)
    }
    
}