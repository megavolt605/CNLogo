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
        case let Bool(value): return ["type": "bool", "value": value]
        case let Int(value): return ["type": "int", "value": value]
        case let Double(value): return ["type": "double", "value": value]
        case let String(value): return ["type": "string", "value": value]
        case let Color(value):
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return [
                "type": "color",
                "value": [
                    "red": red,
                    "green": green,
                    "blue": blue,
                    "alpha": alpha
                ]
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

@warn_unused_result
func ==(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
    
    case (.Unknown, _): return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    case (_, .Unknown): return CNLCValue.Error(block: nil, error: .InvalidValue)
    
    case let (.Bool(lv), .Bool(rv)): return CNLCValue.Bool(value: lv == rv)

    case let (.Double(lv), _):
        switch right {
        case let .Double(rv): return CNLCValue.Bool(value: lv == rv)
        case let .Int(rv): return CNLCValue.Bool(value: lv == Double(rv))
        case let .String(rv): return CNLCValue.Bool(value: lv == rv.doubleValue)
        default: return CNLCValue.Error(block: nil, error: .InvalidValue)
        }
    
    case let (_, .Double(rv)):
        switch left {
        case let .Double(lv): return CNLCValue.Bool(value: lv == rv)
        case let .Int(lv): return CNLCValue.Bool(value: Double(lv) == rv)
        case let .String(lv): return CNLCValue.Bool(value: lv.doubleValue == rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (.Int(lv), _):
        switch right {
        case let .Double(rv): return CNLCValue.Bool(value: Double(lv) == rv)
        case let .Int(rv): return CNLCValue.Bool(value: lv == rv)
        case let .String(rv): return CNLCValue.Bool(value: lv == rv.integerValue)
        default: return  CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (_, .Int(rv)):
        switch left {
        case let .Double(lv): return CNLCValue.Bool(value: lv == Double(rv))
        case let .Int(lv): return CNLCValue.Bool(value: lv == rv)
        case let .String(lv): return CNLCValue.Bool(value: lv.integerValue == rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (.String(lv), _):
        switch right {
        case let .Int(rv): return CNLCValue.Bool(value: lv == rv.description)
        case let .String(rv): return CNLCValue.Bool(value: lv == rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (_, .String(rv)):
        switch left {
        case let .Int(lv): return CNLCValue.Bool(value: lv.description == rv)
        case let .String(lv): return CNLCValue.Bool(value: lv == rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    // TODO: Color comparision

    default: return CNLCValue.Unknown
    }

    
}

@warn_unused_result
func !=(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
        
    case let (.Bool(lv), .Bool(rv)): return CNLCValue.Bool(value: lv != rv)
        
    case let (.Double(lv), _):
        switch right {
        case let .Double(rv): return CNLCValue.Bool(value: lv != rv)
        case let .Int(rv): return CNLCValue.Bool(value: lv != Double(rv))
        case let .String(rv): return CNLCValue.Bool(value: lv != rv.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (_, .Double(rv)):
        switch left {
        case let .Double(lv): return CNLCValue.Bool(value: lv != rv)
        case let .Int(lv): return CNLCValue.Bool(value: Double(lv) != rv)
        case let .String(lv): return CNLCValue.Bool(value: lv.doubleValue != rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (.Int(lv), _):
        switch right {
        case let .Double(rv): return CNLCValue.Bool(value: Double(lv) != rv)
        case let .Int(rv): return CNLCValue.Bool(value: lv != rv)
        case let .String(rv): return CNLCValue.Bool(value: lv != rv.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (_, .Int(rv)):
        switch left {
        case let .Double(lv): return CNLCValue.Bool(value: lv != Double(rv))
        case let .Int(lv): return CNLCValue.Bool(value: lv != rv)
        case let .String(lv): return CNLCValue.Bool(value: lv.integerValue != rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (.String(lv), _):
        switch right {
        case let .Int(rv): return CNLCValue.Bool(value: lv != rv.description)
        case let .String(rv): return CNLCValue.Bool(value: lv != rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let (_, .String(rv)):
        switch left {
        case let .Int(lv): return CNLCValue.Bool(value: lv.description != rv)
        case let .String(lv): return CNLCValue.Bool(value: lv != rv)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
        // TODO: Color comparision
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
    
    
}

@warn_unused_result
func +(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
    
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue + rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue + Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue + rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: Double(leftValue) + rightValue)
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue + rightValue)
        case let .String(rightValue): return CNLCValue.Double(value: Double(leftValue) + rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.String(value: leftValue + "\(rightValue)")
        case let .Int(rightValue): return CNLCValue.String(value: leftValue + "\(rightValue)")
        case let .String(rightValue): return CNLCValue.String(value: leftValue + rightValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func -(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue.doubleValue - rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue.doubleValue - Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue.doubleValue - rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue - rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue - Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue - rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: Double(leftValue) - rightValue)
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue - rightValue)
        case let .String(rightValue): return CNLCValue.Double(value: Double(leftValue) - rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func *(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue.doubleValue * rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue.doubleValue * Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue.doubleValue * rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue * rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue * Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue * (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: Double(leftValue) * rightValue)
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue * rightValue)
        case let .String(rightValue): return CNLCValue.Double(value: Double(leftValue) * (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func /(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue.doubleValue / rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue.doubleValue / Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue.doubleValue / rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue / rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue / Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue / (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: Double(leftValue) / rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: Double(leftValue) / Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

infix operator ^^ {}

@warn_unused_result
func ^^(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: pow(leftValue.doubleValue, rightValue))
        case let .Int(rightValue): return CNLCValue.Double(value: pow(leftValue.doubleValue, Double(rightValue)))
        case let .String(rightValue): return CNLCValue.Double(value: pow(leftValue.doubleValue, rightValue.doubleValue))
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: pow(leftValue, rightValue))
        case let .Int(rightValue): return CNLCValue.Double(value: pow(leftValue, Double(rightValue)))
        case let .String(rightValue): return CNLCValue.Double(value: pow(leftValue, (rightValue as NSString).doubleValue))
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: pow(Double(leftValue), rightValue))
        case let .Int(rightValue): return CNLCValue.Int(value: Int(pow(Double(leftValue), Double(rightValue))))
        case let .String(rightValue): return CNLCValue.Double(value: pow(Double(leftValue), (rightValue as NSString).doubleValue))
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func &&(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
    case let (.Bool(leftValue), .Bool(rightValue)): return CNLCValue.Bool(value: leftValue && rightValue)
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func ||(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
    case let (.Bool(leftValue), .Bool(rightValue)): return CNLCValue.Bool(value: leftValue || rightValue)
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func &(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue.integerValue & rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue.integerValue & rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }

    case let .Int(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue & rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue & rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func |(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue.integerValue | rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue.integerValue | rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue | rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue | rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func %(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue.doubleValue % rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue.doubleValue % Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue.doubleValue % rightValue.doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Double(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: leftValue % rightValue)
        case let .Int(rightValue): return CNLCValue.Double(value: leftValue % Double(rightValue))
        case let .String(rightValue): return CNLCValue.Double(value: leftValue % (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Double(rightValue): return CNLCValue.Double(value: Double(leftValue) / rightValue)
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue % rightValue)
        case let .String(rightValue): return CNLCValue.Double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

@warn_unused_result
func ^(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .String(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue.integerValue ^ rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue.integerValue ^ rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    case let .Int(leftValue):
        switch right {
        case let .Int(rightValue): return CNLCValue.Int(value: leftValue ^ rightValue)
        case let .String(rightValue): return CNLCValue.Int(value: leftValue ^ rightValue.integerValue)
        default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
        }
        
    default: return CNLCValue.Error(block: nil, error: CNLCError.InvalidValue)
    }
}

