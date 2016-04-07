//
//  CNValue.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import UIKit

// lower case (!!!) - intersects with standart swift type names
public enum CNValue {
    case error(block: CNBlock?, error: CNError)
    case unknown
    case bool(value: Bool)
    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    case color(value: UIColor)
    
    public var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
    
    public var description: Swift.String {
        switch self {
        case unknown: return ""
        case let bool(value): return "\(value)"
        case let int(value): return "\(value)"
        case let double(value): return "\(value)"
        case let string(value): return "\"\(value)\""
        case let color(value):
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return "COLOR(red=\(red), green=\(green), blue=\(blue), alpha=\(alpha))"
        case let error(_, anError): return anError.description
        }
    }

    public var typeDescription: Swift.String {
        switch self {
        case unknown: return "unknown"
        case bool: return "bool"
        case int: return "int"
        case double: return "double"
        case string: return "string"
        case color: return "color"
        case error: return "error"
        }
    }

    @warn_unused_result
    func isEqualTo(value: CNValue) -> Bool {
        switch (self, value) {
        case (bool, bool): return true
        case (int, int): return true
        case (double, double): return true
        case (string, string): return true
        case (color, color): return true
        default: return false
        }
    }
    
    @warn_unused_result
    func store() -> [String: AnyObject] {
        switch self {
        case let bool(value): return ["type": "bool", "value": value]
        case let int(value): return ["type": "int", "value": value]
        case let double(value): return ["type": "double", "value": value]
        case let string(value): return ["type": "string", "value": value]
        case let color(value):
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
    public static func loadFromData(data: [String: AnyObject]) -> CNValue {
        if let type = data["type"] as? String {
            switch type {
            case "bool": return bool(value: (data["value"] as? Bool) ?? false)
            case "int": return int(value: (data["value"] as? Int) ?? 0)
            case "double": return double(value: (data["value"] as? Double) ?? 0.0)
            case "string": return string(value: (data["value"] as? String) ?? "")
            case "color":
                if let red = data["red"] as? CGFloat, green = data["green"] as? CGFloat, blue = data["blue"] as? CGFloat, alpha = data["alpha"] as? CGFloat {
                    return color(value: UIColor(red: red, green: green, blue: blue, alpha: alpha))
                }
            default: break
            }
        }
        return unknown
    }
    
}

/*
infix operator == {}
infix operator + {}
infix operator - {}
infix operator * {}
infix operator / {}
infix operator ^^ {}
infix operator && {}
infix operator || {}
infix operator & {}
infix operator | {}
infix operator % {}
infix operator ^ {}
*/

func ==(left: CNValue, right: CNValue) -> CNValue {
    switch (left, right) {
    
    case (.unknown, _): return CNValue.error(block: nil, error: CNError.InvalidValue)
    case (_, .unknown): return CNValue.error(block: nil, error: .InvalidValue)
    
    case let (.bool(lv), .bool(rv)): return CNValue.bool(value: lv == rv)

    case let (.double(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: lv == rv)
        case let .int(rv): return CNValue.bool(value: lv == Double(rv))
        case let .string(rv): return CNValue.bool(value: lv == rv.doubleValue)
        default: return CNValue.error(block: nil, error: .InvalidValue)
        }
    
    case let (_, .double(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv == rv)
        case let .int(lv): return CNValue.bool(value: Double(lv) == rv)
        case let .string(lv): return CNValue.bool(value: lv.doubleValue == rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (.int(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: Double(lv) == rv)
        case let .int(rv): return CNValue.bool(value: lv == rv)
        case let .string(rv): return CNValue.bool(value: lv == rv.integerValue)
        default: return  CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (_, .int(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv == Double(rv))
        case let .int(lv): return CNValue.bool(value: lv == rv)
        case let .string(lv): return CNValue.bool(value: lv.integerValue == rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (.string(lv), _):
        switch right {
        case let .int(rv): return CNValue.bool(value: lv == rv.description)
        case let .string(rv): return CNValue.bool(value: lv == rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (_, .string(rv)):
        switch left {
        case let .int(lv): return CNValue.bool(value: lv.description == rv)
        case let .string(lv): return CNValue.bool(value: lv == rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    // TODO: Color comparision

    default: return CNValue.unknown
    }

    
}

func !=(left: CNValue, right: CNValue) -> CNValue {
    switch (left, right) {
        
    case let (.bool(lv), .bool(rv)): return CNValue.bool(value: lv != rv)
        
    case let (.double(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: lv != rv)
        case let .int(rv): return CNValue.bool(value: lv != Double(rv))
        case let .string(rv): return CNValue.bool(value: lv != rv.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (_, .double(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv != rv)
        case let .int(lv): return CNValue.bool(value: Double(lv) != rv)
        case let .string(lv): return CNValue.bool(value: lv.doubleValue != rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (.int(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: Double(lv) != rv)
        case let .int(rv): return CNValue.bool(value: lv != rv)
        case let .string(rv): return CNValue.bool(value: lv != rv.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (_, .int(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv != Double(rv))
        case let .int(lv): return CNValue.bool(value: lv != rv)
        case let .string(lv): return CNValue.bool(value: lv.integerValue != rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (.string(lv), _):
        switch right {
        case let .int(rv): return CNValue.bool(value: lv != rv.description)
        case let .string(rv): return CNValue.bool(value: lv != rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let (_, .string(rv)):
        switch left {
        case let .int(lv): return CNValue.bool(value: lv.description != rv)
        case let .string(lv): return CNValue.bool(value: lv != rv)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
        // TODO: Color comparision
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
    
    
}


func +(left: CNValue, right: CNValue) -> CNValue {
    switch left {
    
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue + rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue + Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue + rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: Double(leftValue) + rightValue)
        case let .int(rightValue): return CNValue.int(value: leftValue + rightValue)
        case let .string(rightValue): return CNValue.double(value: Double(leftValue) + rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.string(value: leftValue + "\(rightValue)")
        case let .int(rightValue): return CNValue.string(value: leftValue + "\(rightValue)")
        case let .string(rightValue): return CNValue.string(value: leftValue + rightValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func -(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue.doubleValue - rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue.doubleValue - Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue.doubleValue - rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue - rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue - Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue - rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: Double(leftValue) - rightValue)
        case let .int(rightValue): return CNValue.int(value: leftValue - rightValue)
        case let .string(rightValue): return CNValue.double(value: Double(leftValue) - rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func *(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue.doubleValue * rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue.doubleValue * Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue.doubleValue * rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue * rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue * Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue * (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: Double(leftValue) * rightValue)
        case let .int(rightValue): return CNValue.int(value: leftValue * rightValue)
        case let .string(rightValue): return CNValue.double(value: Double(leftValue) * (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func /(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue.doubleValue / rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue.doubleValue / Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue.doubleValue / rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue / rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue / Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue / (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue): return CNValue.double(value: Double(leftValue) / Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

infix operator ^^ {}
func ^^(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: pow(leftValue.doubleValue, rightValue))
        case let .int(rightValue): return CNValue.double(value: pow(leftValue.doubleValue, Double(rightValue)))
        case let .string(rightValue): return CNValue.double(value: pow(leftValue.doubleValue, rightValue.doubleValue))
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: pow(leftValue, rightValue))
        case let .int(rightValue): return CNValue.double(value: pow(leftValue, Double(rightValue)))
        case let .string(rightValue): return CNValue.double(value: pow(leftValue, (rightValue as NSString).doubleValue))
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: pow(Double(leftValue), rightValue))
        case let .int(rightValue): return CNValue.int(value: Int(pow(Double(leftValue), Double(rightValue))))
        case let .string(rightValue): return CNValue.double(value: pow(Double(leftValue), (rightValue as NSString).doubleValue))
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func &&(left: CNValue, right: CNValue) -> CNValue {
    switch (left, right) {
    case let (.bool(leftValue), .bool(rightValue)): return CNValue.bool(value: leftValue && rightValue)
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func ||(left: CNValue, right: CNValue) -> CNValue {
    switch (left, right) {
    case let (.bool(leftValue), .bool(rightValue)): return CNValue.bool(value: leftValue || rightValue)
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func &(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue.integerValue & rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue.integerValue & rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }

    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue & rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue & rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func |(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue.integerValue | rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue.integerValue | rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue | rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue | rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func %(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue.doubleValue % rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue.doubleValue % Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue.doubleValue % rightValue.doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: leftValue % rightValue)
        case let .int(rightValue): return CNValue.double(value: leftValue % Double(rightValue))
        case let .string(rightValue): return CNValue.double(value: leftValue % (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue): return CNValue.int(value: leftValue % rightValue)
        case let .string(rightValue): return CNValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

func ^(left: CNValue, right: CNValue) -> CNValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue.integerValue ^ rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue.integerValue ^ rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNValue.int(value: leftValue ^ rightValue)
        case let .string(rightValue): return CNValue.int(value: leftValue ^ rightValue.integerValue)
        default: return CNValue.error(block: nil, error: CNError.InvalidValue)
        }
        
    default: return CNValue.error(block: nil, error: CNError.InvalidValue)
    }
}

