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
    case error(block: CNLCBlock?, error: CNLCError)
    case unknown
    case bool(value: Swift.Bool)
    case int(value: Swift.Int)
    case double(value: Swift.Double)
    case string(value: Swift.String)
    case color(value: UIColor)
    
    public var isError: Swift.Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
    
    public var description: Swift.String {
        switch self {
        case .unknown: return ""
        case let .bool(value): return "\(value)"
        case let .int(value): return "\(value)"
        case let .double(value): return "\(value)"
        case let .string(value): return "\"\(value)\""
        case let .color(value):
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return "COLOR(red=\(red), green=\(green), blue=\(blue), alpha=\(alpha))"
        case let .error(_, anError): return anError.description
        }
    }

    public var typeDescription: Swift.String {
        switch self {
        case .unknown: return "Unknown"
        case .bool: return "bool"
        case .int: return "int"
        case .double: return "double"
        case .string: return "string"
        case .color: return "color"
        case .error: return "error"
        }
    }

    
    func isEqualTo(_ value: CNLCValue) -> Swift.Bool {
        switch (self, value) {
        case (.bool, .bool): return true
        case (.int, .int): return true
        case (.double, .double): return true
        case (.string, .string): return true
        case (.color, .color): return true
        default: return false
        }
    }
    
    
    func store() -> [Swift.String: Any] {
        switch self {
        case let .bool(value): return ["type": typeDescription as AnyObject, "value": value as AnyObject]
        case let .int(value): return ["type": typeDescription as AnyObject, "value": value as AnyObject]
        case let .double(value): return ["type": typeDescription as AnyObject, "value": value as AnyObject]
        case let .string(value): return ["type": typeDescription as AnyObject, "value": value as AnyObject]
        case let .color(value):
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

    
    public static func loadFromData(_ data: [Swift.String: AnyObject]) -> CNLCValue {
        if let type = data["type"] as? Swift.String {
            switch type {
            case "bool": return bool(value: (data["value"] as? Swift.Bool) ?? false)
            case "int": return int(value: (data["value"] as? Swift.Int) ?? 0)
            case "double": return double(value: (data["value"] as? Swift.Double) ?? 0.0)
            case "string": return string(value: (data["value"] as? Swift.String) ?? "")
            case "color":
                if let red = data["red"] as? CGFloat, let green = data["green"] as? CGFloat, let blue = data["blue"] as? CGFloat, let alpha = data["alpha"] as? CGFloat {
                    return color(value: UIColor(red: red, green: green, blue: blue, alpha: alpha))
                }
            default: break
            }
        }
        return unknown
    }
    
}
