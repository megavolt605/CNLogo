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
enum CNValue {
    case unknown
    case bool(value: Bool)
    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    case color(value: UIColor)
    
    var description: Swift.String {
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
        }
    }
    
    func makeMeDouble() {
        
    }
    
    func throwValueError() throws {
        throw NSError(domain: "Value Error", code: 0, userInfo: nil)
    }
    
}

infix operator ~= {}
func ~=(left: CNValue, right: CNValue) throws -> Bool {
    switch (left, right) {
    case (.bool, .bool): return true
    case (.int, .int): return true
    case (.double, .double): return true
    case (.string, .string): return true
    case (.color, .color): return true
    default: return false
    }
}

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

func ==(left: CNValue, right: CNValue) throws -> CNValue {
    switch (left, right) {
    
    case (.unknown, _): try left.throwValueError()
    case (_, .unknown): try right.throwValueError()
    
    case let (.bool(lv), .bool(rv)): return CNValue.bool(value: lv == rv)

    case let (.double(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: lv == rv)
        case let .int(rv): return CNValue.bool(value: lv == Double(rv))
        case let .string(rv): return CNValue.bool(value: lv == rv.doubleValue)
        default: try right.throwValueError()
        }
    
    case let (_, .double(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv == rv)
        case let .int(lv): return CNValue.bool(value: Double(lv) == rv)
        case let .string(lv): return CNValue.bool(value: lv.doubleValue == rv)
        default: try left.throwValueError()
        }
        
    case let (.int(lv), _):
        switch right {
        case let .double(rv): return CNValue.bool(value: Double(lv) == rv)
        case let .int(rv): return CNValue.bool(value: lv == rv)
        case let .string(rv): return CNValue.bool(value: lv == rv.integerValue)
        default: try right.throwValueError()
        }
        
    case let (_, .int(rv)):
        switch left {
        case let .double(lv): return CNValue.bool(value: lv == Double(rv))
        case let .int(lv): return CNValue.bool(value: lv == rv)
        case let .string(lv): return CNValue.bool(value: lv.integerValue == rv)
        default: try left.throwValueError()
        }
        
    case let (.string(lv), _):
        switch right {
        case let .int(rv): return CNValue.bool(value: lv == rv.description)
        case let .string(rv): return CNValue.bool(value: lv == rv)
        default: try right.throwValueError()
        }
        
    case let (_, .string(rv)):
        switch left {
        case let .int(lv): return CNValue.bool(value: lv.description == rv)
        case let .string(lv): return CNValue.bool(value: lv == rv)
        default: try left.throwValueError()
        }

    // TODO: Color comparision

    default: return CNValue.unknown
    }

    
    return CNValue.unknown
}

func +(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
    
    case .unknown, .bool, .color: try left.throwValueError()
    
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue + rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue + Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue + rightValue.doubleValue)
        }

    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: Double(leftValue) + rightValue)
        case let .int(rightValue):
            return CNValue.int(value: leftValue + rightValue)
        case let .string(rightValue):
            return CNValue.double(value: Double(leftValue) + rightValue.doubleValue)
        }
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.string(value: leftValue + "\(rightValue)")
        case let .int(rightValue):
            return CNValue.string(value: leftValue + "\(rightValue)")
        case let .string(rightValue):
            return CNValue.string(value: leftValue + rightValue)
        }
        
    }
    return CNValue.unknown
}

func -(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .color: try left.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue.doubleValue - rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue.doubleValue - Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue.doubleValue - rightValue.doubleValue)
        }
        
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue - rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue - Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue - rightValue.doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: Double(leftValue) - rightValue)
        case let .int(rightValue):
            return CNValue.int(value: leftValue - rightValue)
        case let .string(rightValue):
            return CNValue.double(value: Double(leftValue) - rightValue.doubleValue)
        }
        
    }
    return CNValue.unknown
}

func *(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue.doubleValue * rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue.doubleValue * Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue.doubleValue * rightValue.doubleValue)
        }
        
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue * rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue * Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue * (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: Double(leftValue) * rightValue)
        case let .int(rightValue):
            return CNValue.int(value: leftValue * rightValue)
        case let .string(rightValue):
            return CNValue.double(value: Double(leftValue) * (rightValue as NSString).doubleValue)
        }
        
    }
    return CNValue.unknown
}

func /(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue.doubleValue / rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue.doubleValue / Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue.doubleValue / rightValue.doubleValue)
        }
        
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue / rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue / Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue / (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue):
            return CNValue.double(value: Double(leftValue) / Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        }
    }
    return CNValue.unknown
}

func ^^(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: pow(leftValue.doubleValue, rightValue))
        case let .int(rightValue):
            return CNValue.double(value: pow(leftValue.doubleValue, Double(rightValue)))
        case let .string(rightValue):
            return CNValue.double(value: pow(leftValue.doubleValue, rightValue.doubleValue))
        }
        
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: pow(leftValue, rightValue))
        case let .int(rightValue):
            return CNValue.double(value: pow(leftValue, Double(rightValue)))
        case let .string(rightValue):
            return CNValue.double(value: pow(leftValue, (rightValue as NSString).doubleValue))
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: pow(Double(leftValue), rightValue))
        case let .int(rightValue):
            return CNValue.int(value: Int(pow(Double(leftValue), Double(rightValue))))
        case let .string(rightValue):
            return CNValue.double(value: pow(Double(leftValue), (rightValue as NSString).doubleValue))
        }
    }
    return CNValue.unknown
}


func &&(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .int, .string, .double, .color: try right.throwValueError()
        
    case let .bool(leftValue):
        switch right {
        case .unknown, .int, .string, .double, .color: try right.throwValueError()
        case let .bool(rightValue):
            return CNValue.bool(value: leftValue && rightValue)
        }
    }
    return CNValue.unknown
}

func ||(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .int, .string, .double, .color: try right.throwValueError()
        
    case let .bool(leftValue):
        switch right {
        case .unknown, .int, .string, .double, .color: try right.throwValueError()
        case let .bool(rightValue):
            return CNValue.bool(value: leftValue || rightValue)
        }
    }
    return CNValue.unknown
}

func &(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .double, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue.integerValue & rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue.integerValue & rightValue.integerValue)
        }

    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue & rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue & rightValue.integerValue)
        }
    }
    return CNValue.unknown
}

func |(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .double, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue.integerValue | rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue.integerValue | rightValue.integerValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue | rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue | rightValue.integerValue)
        }
    }
    return CNValue.unknown
}

func %(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue.doubleValue % rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue.doubleValue % Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue.doubleValue % rightValue.doubleValue)
        }
        
    case let .double(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue % rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue % Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue % (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .color: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue):
            return CNValue.int(value: leftValue % rightValue)
        case let .string(rightValue):
            return CNValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        }
    }
    return CNValue.unknown
}

func ^(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown, .bool, .double, .color: try right.throwValueError()
        
    case let .string(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue.integerValue ^ rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue.integerValue ^ rightValue.integerValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown, .bool, .double, .color: try right.throwValueError()
        case let .int(rightValue):
            return CNValue.int(value: leftValue ^ rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue ^ rightValue.integerValue)
        }
    }
    return CNValue.unknown
}

