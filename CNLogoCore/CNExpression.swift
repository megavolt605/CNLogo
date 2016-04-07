//
//  CNExpression.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public enum CNExpressionParseElementKind {
    case Prefix, Suffix, Infix
}

public enum CNExpressionParseElementAssociativity {
    case Left, Right
}

public enum CNExpressionParseElement {
    case Error(error: CNError)
    case Add, Sub, Mul, Div, Power
    case BoolAnd, BoolOr, BitAnd, BitOr, BitXor, Remainder
    case IsEqual, IsNotEqual, Assign

    case BracketOpen, BracketClose
    case Value(value: CNValue)
    case Variable(variableName: String)
    case Function(functionName: String, functionParameters: [CNExpression])
    
    public var isError: Bool {
        switch self {
        case .Error: return true
        default: return true
        }
    }
    
    public var description: String {
        switch self {
        case Add: return "+"
        case Sub: return "-"
        case Mul: return "*"
        case Div: return "/"
        case Power: return "^^"
        case BoolAnd: return "&&"
        case BoolOr: return "||"
        case BitAnd: return "&"
        case BitOr: return "|"
        case BitXor: return "^"
        case Remainder: return "%"
        case IsEqual: return "=="
        case IsNotEqual: return "!="
        case Assign: return "="
        case BracketOpen: return "("
        case BracketClose: return ")"
        case let Value(value): return value.description
        case let Variable(variableName): return variableName
        case let Function(functionName, _): return "\(functionName)"//(\(functionParameters.description))"
        case let Error(error): return error.description
        }
    }
    
    public func getValue(left: CNExpressionParseElement, _ right: CNExpressionParseElement, _ inBlock: CNBlock) -> CNExpressionParseElement {
        
        let rightValue = left.value(inBlock)
        let leftValue = right.value(inBlock)
        var result: CNValue
        switch self {
        case Add: result = leftValue + rightValue
        case Sub: result = leftValue - rightValue
        case Mul: result = leftValue * rightValue
        case Div: result = leftValue / rightValue
        case Power: result = leftValue ^^ rightValue
        case BoolAnd: result = leftValue && rightValue
        case BoolOr: result = leftValue || rightValue
        case BitAnd: result = leftValue & rightValue
        case BitOr: result = leftValue | rightValue
        case BitXor: result = leftValue ^ rightValue
        case Remainder: result = leftValue % rightValue
        case IsEqual: result = leftValue == rightValue
        case IsNotEqual: result = leftValue != rightValue
        case Assign:
            switch left {
            case let Variable(variableName):
                if let variable = inBlock.variableByName(variableName) {
                    variable.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: rightValue)])
                    return CNExpressionParseElement.Value(value: rightValue)
                } else {
                    result = CNValue.error(block: nil, error: .VariableNotFound(variableName: variableName))
                }
            default: result = CNValue.error(block: nil, error: .AssignToNonVariable)
            }
        default: result = CNValue.error(block: nil, error: .InvalidOperator)
        }
        switch result {
        case let .error(_, error):
            result = CNValue.error(block: inBlock, error: error)
        default: break
        }
        return CNExpressionParseElement.Value(value: result)
    }
    
    public func value(inBlock: CNBlock) -> CNValue {
        switch self {
        case let Value(value): return value
        case let Variable(variableName):
            if let variable = inBlock.variableByName(variableName) {
                return variable.variableValue.execute()
            } else {
                return CNValue.error(block: inBlock, error: .VariableNotFound(variableName: variableName))
            }
        case let Function(functionName, functionParameters):
            if let function = inBlock.functionByName(functionName) {
                return function.executeWithParameters(functionParameters)
            } else {
                return CNValue.error(block: inBlock, error: .FunctionNotFound(functionName: functionName))
            }
        case let .Error(error): return CNValue.error(block: inBlock, error: error)
        default: return CNValue.unknown
        }
    }
    
    func isEqualTo(value: CNExpressionParseElement) -> Bool {
        switch (self, value) {
        case (.Add, .Add): return true
        case (.Sub, .Sub): return true
        case (.Mul, .Mul): return true
        case (.Div, .Div): return true
        case (.Power, .Power): return true
        case (.BoolAnd, .BoolAnd): return true
        case (.BoolOr, .BoolOr): return true
        case (.BitAnd, .BitAnd): return true
        case (.BitOr, .BitOr): return true
        case (.BitXor, .BitXor): return true
        case (.Remainder, .Remainder): return true
        case (.BracketOpen, .BracketOpen): return true
        case (.BracketClose, .BracketClose): return true
        case (.IsEqual, .IsEqual): return true
        case (.IsNotEqual, .IsNotEqual): return true
        default: return false
        }
    }
    
    var weight: Int {
        switch self {
        case BoolAnd, BoolOr: return 100
        case Add, Sub: return 200
        case BitOr: return 250
        case Mul, Div: return 300
        case BitAnd: return 350
        case BitXor, Remainder: return 375
        case Power: return 400
        default: return 0
        }
    }
    
    var kind: CNExpressionParseElementKind {
        return .Infix
    }
    
    var associativity: CNExpressionParseElementAssociativity {
        return .Left
    }
    
    static let operators: [CNExpressionParseElement] = [
        Add, Sub, Mul, Div, Power, BoolAnd, BoolOr, BitAnd, BitOr, BitXor, Remainder, IsEqual, IsNotEqual
    ]

    public func store() -> [String: AnyObject] {
        switch self {
        case Add: return ["type": "add"]
        case Sub: return ["type": "sub"]
        case Mul: return ["type": "mul"]
        case Div: return ["type": "div"]
        case Power: return ["type": "power"]
        case BoolAnd: return ["type": "bool-and"]
        case BoolOr: return ["type": "bool-or"]
        case BitAnd: return ["type": "bit-and"]
        case BitOr: return ["type": "bit-or"]
        case BitXor: return ["type": "bit-xor"]
        case Remainder: return ["type": "remainder"]
        case IsEqual: return ["type": "equal"]
        case IsNotEqual: return ["type": "not-equal"]
        case Assign: return ["type": "assign"]
            
        case BracketOpen: return ["type": "bracket-open"]
        case BracketClose: return ["type": "bracket-close"]
        case let Value(value): return ["type": "value", "value": value.store()]
        case let Variable(variableName): return ["type": "variable", "variable-name": variableName]
        case let Function(function): return [
            "type": "function",
            "function": [
                "function-name": function.functionName,
                "function-params": function.functionParameters.map { $0.store() }
            ]
        ]
        }
    }
    
    public static func loadFromData(data: [String: AnyObject]) -> CNExpressionParseElement {
        if let type = data["type"] as? String {
            switch type {
            case "add": return Add
            case "sub": return Sub
            case "mul": return Mul
            case "div": return Div
            case "power": return Power
            case "bool-and": return BoolAnd
            case "bool-or": return BoolOr
            case "bit-and": return BitAnd
            case "bit-or": return BitOr
            case "bit-xor": return BitXor
            case "remainder": return Remainder
            case "equal": return IsEqual
            case "not-equal": return IsNotEqual
            case "assign": return Assign
                
            case "bracket-open": return BracketOpen
            case "bracket-close": return BracketClose
            case "value":
                if let value = data["value"] as? [String: AnyObject] {
                    return Value(value: CNValue.loadFromData(value))
                }
            case "variable":
                if let variableName = data["variable-name"] as? String {
                    return Variable(variableName: variableName)
                }
            case "function":
                if let function = data["funciton"] as? [String: AnyObject], functionName = function["function-name"] as? String {
                    return Function(
                        functionName: functionName,
                        functionParameters: ((function["function-parameters"] as? [[String: AnyObject]])?.map { item in return CNExpression(data: item) }) ?? []
                    )
                }
            default: break
            }
        }
        fatalError("Invalid element")
    }
    
}

public class CNExpression: CNBlock {
    
    public var source: [CNExpressionParseElement]
    
    override public var identifier: String {
        return "EXPR"
    }
    
    override public var description: String {
        return source.reduce("") {
            return $0 + $1.description
        }
    }
    
    // akslop notation:
    // A + B * C / (D - E) => A B C * D E - / +
    // 
    // A                A
    // +    +           A
    // B    +           A B
    // *    * +         A B
    // C    * +         A B C
    // /    / +         A B C *
    // (    ( / +       A B C *
    // D    ( / +       A B C * D
    // +    -( / +      A B C * D
    // E    -( / +      A B C * D E
    // )    / +         A B C * D E -
    // fin              A B C * D E - / +
    
    private var preparedSource: [CNExpressionParseElement] = []
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        var operatorStack = CNStack<CNExpressionParseElement>()
        preparedSource = []
        for element in source {
            if CNExpressionParseElement.operators.contains({ $0.isEqualTo(element) }) {
                // operator
                repeat {
                    if let oper = operatorStack.peek() {
                        let c1 = ((element.associativity == .Right) && (element.weight < oper.weight))
                        let c2 = ((element.associativity == .Left) && (element.weight <= oper.weight))
                        if CNExpressionParseElement.operators.contains({ $0.isEqualTo(oper) }) && (c1 || c2) {
                            preparedSource.append(operatorStack.pop()!)
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                } while true
                operatorStack.push(element)
            } else {
                // not operator
                switch element {
                case .Value, .Variable:
                    preparedSource.append(element)
                case let .Function(function):
                    for parameter in function.functionParameters {
                        prepared = parameter.prepare()
                        if prepared.isError { return prepared }
                    }
                    preparedSource.append(element)
                case .BracketOpen:
                    operatorStack.push(element)
                case .BracketClose:
                    repeat {
                        if let oper = operatorStack.pop() {
                            if oper.isEqualTo(CNExpressionParseElement.BracketOpen) {
                                break
                            }
                            preparedSource.append(oper)
                        } else {
                            return CNBlockPrepareResult.Error(block: self, error: .InvalidExpression)
                        }
                    } while true
                default:
                    return CNBlockPrepareResult.Error(block: self, error: .InvalidExpression)
                }
            }
        }
        while operatorStack.count > 0 {
            preparedSource.append(operatorStack.pop()!)
        }
        //preparedSource = preparedSource.reverse()
    }
    
    override public func execute() -> CNValue {
        let result = super.execute()
        if result.isError { return result }
        
        var resultStack = CNStack<CNExpressionParseElement>()
        for element in preparedSource {
            if CNExpressionParseElement.operators.contains({ $0.isEqualTo(element) }) {
                // operator
                switch element.kind {
                case .Infix:
                    let left = resultStack.pop()!
                    let right = resultStack.pop()!
                    let value = element.getValue(left, right, self)
                    if value.isError { return value.value(self) }
                    resultStack.push(value)
                default: return .unknown
                }
            } else {
                resultStack.push(element)
            }
            
        }
        
        if let finalResult = resultStack.pop() {
            return finalResult.value(self)
        } else {
            return CNValue.error(block: self, error: .InvalidExpression)
        }
    }

    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["source"] = source.map { $0.store() }
        return res
    }

    public init(source: [CNExpressionParseElement]) {
        self.source = source
        super.init()
    }
    
    public required init(data: [String: AnyObject]) {
        source = []
        super.init(data: data)
        if let info = data["source"] as? [[String: AnyObject]] {
            source = info.map { item in return CNExpressionParseElement.loadFromData(item) }
        }
    }

}