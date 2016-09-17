//
//  CNLCValueOperators.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 10/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import UIKit


func ==(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
        
    case (.unknown, _): return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    case (_, .unknown): return CNLCValue.error(block: nil, error: .invalidValue)
        
    case let (.bool(lv), .bool(rv)): return CNLCValue.bool(value: lv == rv)
        
    case let (.double(lv), _):
        switch right {
        case let .double(rv): return CNLCValue.bool(value: lv == rv)
        case let .int(rv): return CNLCValue.bool(value: lv == Double(rv))
        case let .string(rv): return CNLCValue.bool(value: lv == rv.doubleValue)
        default: return CNLCValue.error(block: nil, error: .invalidValue)
        }
        
    case let (_, .double(rv)):
        switch left {
        case let .double(lv): return CNLCValue.bool(value: lv == rv)
        case let .int(lv): return CNLCValue.bool(value: Double(lv) == rv)
        case let .string(lv): return CNLCValue.bool(value: lv.doubleValue == rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (.int(lv), _):
        switch right {
        case let .double(rv): return CNLCValue.bool(value: Double(lv) == rv)
        case let .int(rv): return CNLCValue.bool(value: lv == rv)
        case let .string(rv): return CNLCValue.bool(value: lv == rv.integerValue)
        default: return  CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (_, .int(rv)):
        switch left {
        case let .double(lv): return CNLCValue.bool(value: lv == Double(rv))
        case let .int(lv): return CNLCValue.bool(value: lv == rv)
        case let .string(lv): return CNLCValue.bool(value: lv.integerValue == rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (.string(lv), _):
        switch right {
        case let .int(rv): return CNLCValue.bool(value: lv == rv.description)
        case let .string(rv): return CNLCValue.bool(value: lv == rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (_, .string(rv)):
        switch left {
        case let .int(lv): return CNLCValue.bool(value: lv.description == rv)
        case let .string(lv): return CNLCValue.bool(value: lv == rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
        // TODO: Color comparision
        
    default: return CNLCValue.unknown
    }
    
    
}


func !=(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
        
    case let (.bool(lv), .bool(rv)): return CNLCValue.bool(value: lv != rv)
        
    case let (.double(lv), _):
        switch right {
        case let .double(rv): return CNLCValue.bool(value: lv != rv)
        case let .int(rv): return CNLCValue.bool(value: lv != Double(rv))
        case let .string(rv): return CNLCValue.bool(value: lv != rv.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (_, .double(rv)):
        switch left {
        case let .double(lv): return CNLCValue.bool(value: lv != rv)
        case let .int(lv): return CNLCValue.bool(value: Double(lv) != rv)
        case let .string(lv): return CNLCValue.bool(value: lv.doubleValue != rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (.int(lv), _):
        switch right {
        case let .double(rv): return CNLCValue.bool(value: Double(lv) != rv)
        case let .int(rv): return CNLCValue.bool(value: lv != rv)
        case let .string(rv): return CNLCValue.bool(value: lv != rv.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (_, .int(rv)):
        switch left {
        case let .double(lv): return CNLCValue.bool(value: lv != Double(rv))
        case let .int(lv): return CNLCValue.bool(value: lv != rv)
        case let .string(lv): return CNLCValue.bool(value: lv.integerValue != rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (.string(lv), _):
        switch right {
        case let .int(rv): return CNLCValue.bool(value: lv != rv.description)
        case let .string(rv): return CNLCValue.bool(value: lv != rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let (_, .string(rv)):
        switch left {
        case let .int(lv): return CNLCValue.bool(value: lv.description != rv)
        case let .string(lv): return CNLCValue.bool(value: lv != rv)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
        // TODO: Color comparision
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
    
    
}


func +(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue + rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue + Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue + rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: Double(leftValue) + rightValue)
        case let .int(rightValue): return CNLCValue.int(value: leftValue + rightValue)
        case let .string(rightValue): return CNLCValue.double(value: Double(leftValue) + rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.string(value: leftValue + "\(rightValue)")
        case let .int(rightValue): return CNLCValue.string(value: leftValue + "\(rightValue)")
        case let .string(rightValue): return CNLCValue.string(value: leftValue + rightValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func -(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue.doubleValue - rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue.doubleValue - Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue.doubleValue - rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue - rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue - Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue - rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: Double(leftValue) - rightValue)
        case let .int(rightValue): return CNLCValue.int(value: leftValue - rightValue)
        case let .string(rightValue): return CNLCValue.double(value: Double(leftValue) - rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func *(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue.doubleValue * rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue.doubleValue * Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue.doubleValue * rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue * rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue * Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue * (rightValue as NSString).doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: Double(leftValue) * rightValue)
        case let .int(rightValue): return CNLCValue.int(value: leftValue * rightValue)
        case let .string(rightValue): return CNLCValue.double(value: Double(leftValue) * (rightValue as NSString).doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func /(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue.doubleValue / rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue.doubleValue / Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue.doubleValue / rightValue.doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue / rightValue)
        case let .int(rightValue): return CNLCValue.double(value: leftValue / Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: leftValue / (rightValue as NSString).doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue): return CNLCValue.double(value: Double(leftValue) / Double(rightValue))
        case let .string(rightValue): return CNLCValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}

infix operator ^^


func ^^(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: pow(leftValue.doubleValue, rightValue))
        case let .int(rightValue): return CNLCValue.double(value: pow(leftValue.doubleValue, Double(rightValue)))
        case let .string(rightValue): return CNLCValue.double(value: pow(leftValue.doubleValue, rightValue.doubleValue))
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: pow(leftValue, rightValue))
        case let .int(rightValue): return CNLCValue.double(value: pow(leftValue, Double(rightValue)))
        case let .string(rightValue): return CNLCValue.double(value: pow(leftValue, (rightValue as NSString).doubleValue))
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: pow(Double(leftValue), rightValue))
        case let .int(rightValue): return CNLCValue.int(value: Int(pow(Double(leftValue), Double(rightValue))))
        case let .string(rightValue): return CNLCValue.double(value: pow(Double(leftValue), (rightValue as NSString).doubleValue))
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func &&(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
    case let (.bool(leftValue), .bool(rightValue)): return CNLCValue.bool(value: leftValue && rightValue)
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func ||(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch (left, right) {
    case let (.bool(leftValue), .bool(rightValue)): return CNLCValue.bool(value: leftValue || rightValue)
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func &(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue.integerValue & rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue.integerValue & rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue & rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue & rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func |(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue.integerValue | rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue.integerValue | rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue | rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue | rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func %(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue.doubleValue.truncatingRemainder(dividingBy: rightValue))
        case let .int(rightValue): return CNLCValue.double(value: leftValue.doubleValue.truncatingRemainder(dividingBy: Double(rightValue)))
        case let .string(rightValue): return CNLCValue.double(value: leftValue.doubleValue.truncatingRemainder(dividingBy: rightValue.doubleValue))
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .double(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: leftValue.truncatingRemainder(dividingBy: rightValue))
        case let .int(rightValue): return CNLCValue.double(value: leftValue.truncatingRemainder(dividingBy: Double(rightValue)))
        case let .string(rightValue): return CNLCValue.double(value: leftValue.truncatingRemainder(dividingBy: (rightValue as NSString).doubleValue))
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .double(rightValue): return CNLCValue.double(value: Double(leftValue) / rightValue)
        case let .int(rightValue): return CNLCValue.int(value: leftValue % rightValue)
        case let .string(rightValue): return CNLCValue.double(value: Double(leftValue) / (rightValue as NSString).doubleValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}


func ^(left: CNLCValue, right: CNLCValue) -> CNLCValue {
    switch left {
        
    case let .string(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue.integerValue ^ rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue.integerValue ^ rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    case let .int(leftValue):
        switch right {
        case let .int(rightValue): return CNLCValue.int(value: leftValue ^ rightValue)
        case let .string(rightValue): return CNLCValue.int(value: leftValue ^ rightValue.integerValue)
        default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
        }
        
    default: return CNLCValue.error(block: nil, error: CNLCError.invalidValue)
    }
}
