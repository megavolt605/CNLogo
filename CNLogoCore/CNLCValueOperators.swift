//
//  CNLCValueOperators.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 10/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import UIKit

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
