//
//  CNLUIT+UIColor.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public extension UIColor {
    
    public class func colorWithInt(red: UInt, green: UInt, blue: UInt, alpha: UInt) -> UIColor {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public class func colorWith(hex: UInt) -> UIColor {
        let red = hex % 0x100
        let green = (hex >> 8) % 0x100
        let blue = (hex >> 16) % 0x100
        let alpha = (hex >> 24) % 0x100
        return UIColor.colorWithInt(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public class func colorWith(string: String?, reverse: Bool = false) -> UIColor? {
        if let stringColor = string, let reversedColor = UInt(stringColor, radix: 16) {
            if reverse {
                let color =
                    ((reversedColor & 0x000000FF) << 16) |
                        ((reversedColor & 0x00FF0000) >> 16) |
                        (reversedColor & 0xFF00FF00)
                return UIColor.colorWith(hex: color)
            } else {
                return UIColor.colorWith(hex: reversedColor)
            }
        }
        return nil
    }
    
    public func hexIntVaue(reversed: Bool = false) -> UInt {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let hexRed = UInt(255.0 * red)
            let hexGreen = UInt(255.0 * green) << 8
            let hexBlue = UInt(255.0 * blue) << 16
            let hexAlpha = UInt(255.0 * alpha) << 24
            let color = hexRed | hexGreen | hexBlue | hexAlpha
            if reversed {
                let reversedColor =
                    ((color & 0x000000FF) << 16) |
                        ((color & 0x00FF0000) >> 16) |
                        (color & 0xFF00FF00)
                return reversedColor
            } else {
                return color
            }
        }
        // opaque black by default
        return 0xFF000000
    }
    
    public func hexValue(reversed: Bool = false) -> String {
        let value = hexIntVaue(reversed: reversed)
        return String(format: "%08x", value)
    }
    
}

/*
extension UIColor: CNLDictionaryDecodable {
    public static func decodeValue(_ any: Any) -> Self? {
        if let value = any as? UInt {
            return self.colorWith(hex: value)
        }
        return nil
    }
    public func encodeValue() -> Any? { return hexValue() }
}
*/
