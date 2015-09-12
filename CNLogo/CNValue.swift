//
//  CNValue.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

// lower case (!!!) - intersects with standart swift type names
enum CNValue {
    case unknown
    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    
    var description: Swift.String {
        switch self {
        case .unknown: return ""
        case .int(let value): return "\(value)"
        case .double(let value): return "\(value)"
        case .string(let value): return "\(value)"
        }
    }
    
    func makeMeDouble() {
        
    }
    
    func throwValueError() throws {
        throw NSError(domain: "Value Error", code: 0, userInfo: nil)
    }
    
}

infix operator + {}
infix operator - {}
infix operator * {}
infix operator / {}

func +(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
    
    case .unknown: try left.throwValueError()
    
    case let .double(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue + rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue + Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue + (rightValue as NSString).doubleValue)
        }

    case let .int(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.int(value: leftValue + Int(rightValue))
        case let .int(rightValue):
            return CNValue.int(value: leftValue + rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue + (rightValue as NSString).integerValue)
        }
        
    case let .string(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
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
        
    case .unknown: try left.throwValueError()
        
    case let .double(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue - rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue - Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue - (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.int(value: leftValue - Int(rightValue))
        case let .int(rightValue):
            return CNValue.int(value: leftValue - rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue - (rightValue as NSString).integerValue)
        }
        
    case .string(_):
        try right.throwValueError()
    }
    return CNValue.unknown
}

func *(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown: try left.throwValueError()
        
    case let .double(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue * rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue * Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue * (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.int(value: leftValue * Int(rightValue))
        case let .int(rightValue):
            return CNValue.int(value: leftValue * rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue * (rightValue as NSString).integerValue)
        }
        
    case .string(_):
        try right.throwValueError()
    }
    return CNValue.unknown
}

func /(left: CNValue, right: CNValue) throws -> CNValue {
    switch left {
        
    case .unknown: try left.throwValueError()
        
    case let .double(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.double(value: leftValue / rightValue)
        case let .int(rightValue):
            return CNValue.double(value: leftValue / Double(rightValue))
        case let .string(rightValue):
            return CNValue.double(value: leftValue / (rightValue as NSString).doubleValue)
        }
        
    case let .int(leftValue):
        switch right {
        case .unknown: try right.throwValueError()
        case let .double(rightValue):
            return CNValue.int(value: leftValue / Int(rightValue))
        case let .int(rightValue):
            return CNValue.int(value: leftValue / rightValue)
        case let .string(rightValue):
            return CNValue.int(value: leftValue / (rightValue as NSString).integerValue)
        }
        
    case .string(_):
        try right.throwValueError()
    }
    return CNValue.unknown
}