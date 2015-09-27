//
//  CNExpression.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

enum CNExpressionParseElementKind {
    case Prefix, Suffix, Infix
}

enum CNExpressionParseElementAssociativity {
    case Left, Right
}

enum CNExpressionParseElement {
    case Add, Sub, Mul, Div, Power
    case BoolAnd, BoolOr, BitAnd, BitOr, BitXor, Remainder
    case IsEqual, Assign

    case BracketOpen, BracketClose
    case Value(value: CNValue)
    case Variable(name: String)
    case Function(name: String, parameters: [CNExpression])
    
    var description: String {
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
        case Assign: return "="
        case BracketOpen: return "("
        case BracketClose: return ")"
        case let Value(value): return value.description
        case let Variable(name): return name
        case let Function(name, parameters): return "\(name)(\(parameters.description))"
        }
    }
    
    func getValue(left: CNExpressionParseElement, _ right: CNExpressionParseElement, _ inBlock: CNBlock) throws -> CNExpressionParseElement {
        
        let rightValue = try left.value(inBlock)
        let leftValue = try right.value(inBlock)

        switch self {
        case Add: return CNExpressionParseElement.Value(value: try leftValue + rightValue)
        case Sub: return CNExpressionParseElement.Value(value: try leftValue - rightValue)
        case Mul: return CNExpressionParseElement.Value(value: try leftValue * rightValue)
        case Div: return CNExpressionParseElement.Value(value: try leftValue / rightValue)
        case Power: return CNExpressionParseElement.Value(value: try leftValue ^^ rightValue)
        case BoolAnd: return CNExpressionParseElement.Value(value: try leftValue && rightValue)
        case BoolOr: return CNExpressionParseElement.Value(value: try leftValue || rightValue)
        case BitAnd: return CNExpressionParseElement.Value(value: try leftValue & rightValue)
        case BitOr: return CNExpressionParseElement.Value(value: try leftValue | rightValue)
        case BitXor: return CNExpressionParseElement.Value(value: try leftValue ^ rightValue)
        case Remainder: return CNExpressionParseElement.Value(value: try leftValue % rightValue)
        case IsEqual: return CNExpressionParseElement.Value(value: try leftValue == rightValue)
        case Assign:
            switch left {
            case let Variable(name):
                if let variable = inBlock.variableByName(name) {
                    variable.value = rightValue
                    return CNExpressionParseElement.Value(value: rightValue)
                } else {
                     throw NSError(domain: "Variable not found \(name)", code: 0, userInfo: nil)
                }
            default: throw NSError(domain: "Invalid operator", code: 0, userInfo: nil)
            }
        default: throw NSError(domain: "Invalid operator", code: 0, userInfo: nil)
        }
    }
    
    func value(inBlock: CNBlock) throws -> CNValue {
        switch self {
        case let Value(value): return value
        case let Variable(name):
            if let variable = inBlock.variableByName(name) {
                return variable.value
            } else {
                throw NSError(domain: "Variable not found \(name)", code: 0, userInfo: nil)
            }
        case let Function(name, parameters):
            if let function = inBlock.functionByName(name) {
                return try function.executeWithParameters(parameters)
            } else {
                throw NSError(domain: "Function not found \(name)", code: 0, userInfo: nil)
            }
        default: return CNValue.unknown
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
        Add, Sub, Mul, Div, Power, BoolAnd, BoolOr, BitAnd, BitOr, BitXor, Remainder
    ]
    
}

extension CNExpressionParseElement: Equatable {
    
}

infix operator == {}
func ==(lhs: CNExpressionParseElement, rhs: CNExpressionParseElement) -> Bool {
    switch (lhs, rhs) {
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
    default: return false
    }
}

class CNExpression: CNBlock {
    
    var source: [CNExpressionParseElement]
    
    override var name: String {
        return ""
    }
    
    override var description: String {
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
    override func prepare() throws {
        try super.prepare()
        var operatorStack = CNStack<CNExpressionParseElement>()
        preparedSource = []
        for element in source {
            if CNExpressionParseElement.operators.contains({$0 == element}) {
                // operator
                repeat {
                    if let oper = operatorStack.peek() {
                        let c1 = ((element.associativity == .Right) && (element.weight < oper.weight))
                        let c2 = ((element.associativity == .Left) && (element.weight <= oper.weight))
                        if CNExpressionParseElement.operators.contains({$0 == oper}) && (c1 || c2) {
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
                    try function.parameters.forEach {
                        try $0.prepare()
                    }
                    preparedSource.append(element)
                case .BracketOpen:
                    operatorStack.push(element)
                case .BracketClose:
                    repeat {
                        if let oper = operatorStack.pop() {
                            if oper == CNExpressionParseElement.BracketOpen {
                                break
                            }
                            preparedSource.append(oper)
                        } else {
                            throw NSError(domain: "Invalid expression", code: 0, userInfo: nil)
                        }
                    } while true
                default: throw NSError(domain: "Invalid expression", code: 0, userInfo: nil)
                }
            }
        }
        while operatorStack.count > 0 {
            preparedSource.append(operatorStack.pop()!)
        }
        //preparedSource = preparedSource.reverse()
    }
    
    override func execute() throws -> CNValue {
        try super.execute()

        var result = CNStack<CNExpressionParseElement>()
        try preparedSource.forEach { element in
            if CNExpressionParseElement.operators.contains({$0 == element}) {
                // operator
                switch element.kind {
                case .Infix:
                    let left = result.pop()!
                    let right = result.pop()!
                    result.push(try element.getValue(left, right, self))
                default: return
                }
            } else {
                result.push(element)
            }
            
        }
        
        return try result.pop()!.value(self)
    }

    init(source: [CNExpressionParseElement]) {
        self.source = source
        super.init(statements: [])
    }
    
}