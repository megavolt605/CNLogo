//
//  CNLCExpressionParseElement.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

public enum CNLCExpressionParseElementKind {
    case prefix, suffix, infix
}

public enum CNLCExpressionParseElementAssociativity {
    case left, right
}

public enum CNLCExpressionParseElement {
    case error(error: CNLCError)
    case add, sub, mul, div, power
    case boolAnd, boolOr, bitAnd, bitOr, bitXor, remainder
    case isEqual, isNotEqual, assign
    
    case bracketOpen, bracketClose
    case Value(value: CNLCValue)
    case variable(variableName: String)
    case function(functionName: String, functionParameters: [CNLCExpression])
    
    public var isError: Bool {
        switch self {
        case .error: return true
        default: return true
        }
    }
    
    public var description: String {
        switch self {
        case .add: return "+"
        case .sub: return "-"
        case .mul: return "*"
        case .div: return "/"
        case .power: return "^^"
        case .boolAnd: return "&&"
        case .boolOr: return "||"
        case .bitAnd: return "&"
        case .bitOr: return "|"
        case .bitXor: return "^"
        case .remainder: return "%"
        case .isEqual: return "=="
        case .isNotEqual: return "!="
        case .assign: return "="
        case .bracketOpen: return "("
        case .bracketClose: return ")"
        case let .Value(value): return value.description
        case let .variable(variableName): return variableName
        case let .function(functionName, _): return "\(functionName)"//(\(functionParameters.description))"
        case let .error(error): return error.description
        }
    }
    
    public func getValue(_ left: CNLCExpressionParseElement, _ right: CNLCExpressionParseElement, _ inBlock: CNLCBlock) -> CNLCExpressionParseElement {
        
        let rightValue = left.value(inBlock)
        let leftValue = right.value(inBlock)
        var result: CNLCValue
        switch self {
        case .add: result = leftValue + rightValue
        case .sub: result = leftValue - rightValue
        case .mul: result = leftValue * rightValue
        case .div: result = leftValue / rightValue
        case .power: result = leftValue ^^ rightValue
        case .boolAnd: result = leftValue && rightValue
        case .boolOr: result = leftValue || rightValue
        case .bitAnd: result = leftValue & rightValue
        case .bitOr: result = leftValue | rightValue
        case .bitXor: result = leftValue ^ rightValue
        case .remainder: result = leftValue % rightValue
        case .isEqual: result = leftValue == rightValue
        case .isNotEqual: result = leftValue != rightValue
        case .assign:
            switch left {
            case let .variable(variableName):
                if let variable = inBlock.variableByName(variableName) {
                    variable.variableValue = CNLCExpression(source: [CNLCExpressionParseElement.Value(value: rightValue)])
                    return CNLCExpressionParseElement.Value(value: rightValue)
                } else {
                    result = .error(block: nil, error: .variableNotFound(variableName: variableName))
                }
            default: result = .error(block: nil, error: .assignToNonVariable)
            }
        default: result = .error(block: nil, error: .invalidOperator)
        }
        switch result {
        case let .error(_, error):
            result = .error(block: inBlock, error: error)
        default: break
        }
        return CNLCExpressionParseElement.Value(value: result)
    }
    
    public func value(_ inBlock: CNLCBlock) -> CNLCValue {
        switch self {
        case let .Value(value): return value
        case let .variable(variableName):
            if let variable = inBlock.variableByName(variableName) {
                return variable.variableValue.execute()
            } else {
                return .error(block: inBlock, error: .variableNotFound(variableName: variableName))
            }
        case let .function(functionName, functionParameters):
            if let function = inBlock.functionByName(functionName) {
                return function.execute(functionParameters)
            } else {
                return .error(block: inBlock, error: .functionNotFound(functionName: functionName))
            }
        case let .error(error): return .error(block: inBlock, error: error)
        default: return .unknown
        }
    }
    
    func isEqualTo(_ value: CNLCExpressionParseElement) -> Bool {
        switch (self, value) {
        case (.add, .add): return true
        case (.sub, .sub): return true
        case (.mul, .mul): return true
        case (.div, .div): return true
        case (.power, .power): return true
        case (.boolAnd, .boolAnd): return true
        case (.boolOr, .boolOr): return true
        case (.bitAnd, .bitAnd): return true
        case (.bitOr, .bitOr): return true
        case (.bitXor, .bitXor): return true
        case (.remainder, .remainder): return true
        case (.bracketOpen, .bracketOpen): return true
        case (.bracketClose, .bracketClose): return true
        case (.isEqual, .isEqual): return true
        case (.isNotEqual, .isNotEqual): return true
        default: return false
        }
    }
    
    var weight: Int {
        switch self {
        case .boolAnd, .boolOr: return 100
        case .add, .sub: return 200
        case .bitOr: return 250
        case .mul, .div: return 300
        case .bitAnd: return 350
        case .bitXor, .remainder: return 375
        case .power: return 400
        default: return 0
        }
    }
    
    var kind: CNLCExpressionParseElementKind {
        return .infix
    }
    
    var associativity: CNLCExpressionParseElementAssociativity {
        return .left
    }
    
    static let operators: [CNLCExpressionParseElement] = [
        add, sub, mul, div, power, boolAnd, boolOr, bitAnd, bitOr, bitXor, remainder, isEqual, isNotEqual
    ]
    
    public func store() -> [String: Any] {
        switch self {
        case .add: return ["type": "add" as AnyObject]
        case .sub: return ["type": "sub" as AnyObject]
        case .mul: return ["type": "mul" as AnyObject]
        case .div: return ["type": "div" as AnyObject]
        case .power: return ["type": "power" as AnyObject]
        case .boolAnd: return ["type": "bool-and" as AnyObject]
        case .boolOr: return ["type": "bool-or" as AnyObject]
        case .bitAnd: return ["type": "bit-and" as AnyObject]
        case .bitOr: return ["type": "bit-or" as AnyObject]
        case .bitXor: return ["type": "bit-xor" as AnyObject]
        case .remainder: return ["type": "remainder" as AnyObject]
        case .isEqual: return ["type": "equal" as AnyObject]
        case .isNotEqual: return ["type": "not-equal" as AnyObject]
        case .assign: return ["type": "assign" as AnyObject]
            
        case .bracketOpen: return ["type": "bracket-open" as AnyObject]
        case .bracketClose: return ["type": "bracket-close" as AnyObject]
        case let .Value(value): return ["type": "value" as AnyObject, "value": value.store() as AnyObject]
        case let .variable(variableName): return ["type": "variable" as AnyObject, "variable-name": variableName as AnyObject]
        case let .function(function): return [
            "type": "function" as AnyObject,
            "function": [
                "function-name": function.functionName,
                "function-params": function.functionParameters.map { $0.store() }
            ]
            ]
        case .error: return [:]
        }
    }
    
    public static func loadFromData(_ data: [String: Any]) -> CNLCExpressionParseElement {
        if let type = data["type"] as? String {
            switch type {
            case "add": return add
            case "sub": return sub
            case "mul": return mul
            case "div": return div
            case "power": return power
            case "bool-and": return boolAnd
            case "bool-or": return boolOr
            case "bit-and": return bitAnd
            case "bit-or": return bitOr
            case "bit-xor": return bitXor
            case "remainder": return remainder
            case "equal": return isEqual
            case "not-equal": return isNotEqual
            case "assign": return assign
                
            case "bracket-open": return bracketOpen
            case "bracket-close": return bracketClose
            case "value":
                if let value = data["value"] as? [String: Any] {
                    return Value(value: CNLCValue.loadFromData(value as [String : AnyObject]))
                }
            case "variable":
                if let variableName = data["variable-name"] as? String {
                    return variable(variableName: variableName)
                }
            case "function":
                if let function = data["funciton"] as? [String: Any], let functionName = function["function-name"] as? String {
                    return self.function(
                        functionName: functionName,
                        functionParameters: ((function["function-parameters"] as? [[String: Any]])?.map { item in return CNLCExpression(data: item) }) ?? []
                    )
                }
            default: break
            }
        }
        fatalError("Invalid element")
    }
    
}
