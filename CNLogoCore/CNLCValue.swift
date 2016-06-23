//
//  CNLCValue.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import UIKit // needs for UIColor, CoreGraphics

/// Represents a value of some type.
/// 
/// Possible types: 
/// - Error: error value
/// - Unknown: null value
/// - Bool: boolean value
/// - Int: integer value
/// - Double: floating point value
/// - String: string value
/// - Color: color value

public enum CNLCValue {
    case Error(block: CNLCBlock?, error: CNLCError)
    case Unknown
    case Bool(value: Swift.Bool)
    case Int(value: Swift.Int)
    case Double(value: Swift.Double)
    case String(value: Swift.String)
    case Color(value: UIColor)
    
    public var isError: Swift.Bool {
        switch self {
        case Error: return true
        default: return false
        }
    }
    
    public var description: Swift.String {
        switch self {
        case Unknown: return ""
        case let Bool(value): return "\(value)"
        case let Int(value): return "\(value)"
        case let Double(value): return "\(value)"
        case let String(value): return "\"\(value)\""
        case let Color(value):
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return "COLOR(red=\(red), green=\(green), blue=\(blue), alpha=\(alpha))"
        case let Error(_, anError): return anError.description
        }
    }

    public var typeDescription: Swift.String {
        switch self {
        case Unknown: return "Unknown"
        case Bool: return "bool"
        case Int: return "int"
        case Double: return "double"
        case String: return "string"
        case Color: return "color"
        case Error: return "error"
        }
    }

    @warn_unused_result
    func isEqualTo(value: CNLCValue) -> Swift.Bool {
        switch (self, value) {
        case (Bool, Bool): return true
        case (Int, Int): return true
        case (Double, Double): return true
        case (String, String): return true
        case (Color, Color): return true
        default: return false
        }
    }
    
    @warn_unused_result
    func store() -> [Swift.String: AnyObject] {
        switch self {
        case let Bool(value): return ["type": typeDescription, "value": value]
        case let Int(value): return ["type": typeDescription, "value": value]
        case let Double(value): return ["type": typeDescription, "value": value]
        case let String(value): return ["type": typeDescription, "value": value]
        case let Color(value):
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return [
                "type": typeDescription,
                "value": ["red": red, "green": green, "blue": blue, "alpha": alpha]
            ]
        default: return [:]
        }
    }

    @warn_unused_result
    public static func loadFromData(data: [Swift.String: AnyObject]) -> CNLCValue {
        if let type = data["type"] as? Swift.String {
            switch type {
            case "bool": return Bool(value: (data["value"] as? Swift.Bool) ?? false)
            case "int": return Int(value: (data["value"] as? Swift.Int) ?? 0)
            case "double": return Double(value: (data["value"] as? Swift.Double) ?? 0.0)
            case "string": return String(value: (data["value"] as? Swift.String) ?? "")
            case "color":
                if let red = data["red"] as? CGFloat, green = data["green"] as? CGFloat, blue = data["blue"] as? CGFloat, alpha = data["alpha"] as? CGFloat {
                    return Color(value: UIColor(red: red, green: green, blue: blue, alpha: alpha))
                }
            default: break
            }
        }
        return Unknown
    }
    
}
