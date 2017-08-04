//
//  CNLCExpression.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

open class CNLCExpression: CNLCBlock {
    
    open var source: [CNLCExpressionParseElement]
    
    override open var identifier: String {
        return "EXPR"
    }
    
    override open var description: String {
        return source.reduce("") {
            return $0 + $1.description
        }
    }
    
    // akslop notation:
    // A+B*C/(D-E) => ABC*DE-/+
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
    
    fileprivate var preparedSource: [CNLCExpressionParseElement] = []
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        var operatorStack = CNLCStack<CNLCExpressionParseElement>()
        preparedSource = []
        for element in source {
            if CNLCExpressionParseElement.operators.contains(where: { $0.isEqualTo(element) }) {
                // operator
                repeat {
                    if let oper = operatorStack.peek() {
                        let c1 = ((element.associativity == .right) && (element.weight < oper.weight))
                        let c2 = ((element.associativity == .left) && (element.weight <= oper.weight))
                        if CNLCExpressionParseElement.operators.contains(where: { $0.isEqualTo(oper) }) && (c1 || c2) {
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
                case .Value, .variable:
                    preparedSource.append(element)
                case let .function(function):
                    for parameter in function.functionParameters {
                        prepared = parameter.prepare()
                        if prepared.isError { return prepared }
                    }
                    preparedSource.append(element)
                case .bracketOpen:
                    operatorStack.push(element)
                case .bracketClose:
                    repeat {
                        if let oper = operatorStack.pop() {
                            if oper.isEqualTo(CNLCExpressionParseElement.bracketOpen) {
                                break
                            }
                            preparedSource.append(oper)
                        } else {
                            return CNLCBlockPrepareResult.error(block: self, error: .invalidExpression)
                        }
                    } while true
                default:
                    return CNLCBlockPrepareResult.error(block: self, error: .invalidExpression)
                }
            }
        }
        while operatorStack.count > 0 {
            preparedSource.append(operatorStack.pop()!)
        }
        //preparedSource = preparedSource.reverse()
        return result
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }
        
        var resultStack = CNLCStack<CNLCExpressionParseElement>()
        for element in preparedSource {
            if CNLCExpressionParseElement.operators.contains(where: { $0.isEqualTo(element) }) {
                // operator
                switch element.kind {
                case .infix:
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
            return .error(block: self, error: .invalidExpression)
        }
    }

    override open func store() -> [String: Any] {
        var res = super.store()
        res["source"] = source.map { $0.store() }
        return res
    }

    public init(source: [CNLCExpressionParseElement]) {
        self.source = source
        super.init()
    }
    
    override public init(data: [String: Any]) {
        source = []
        super.init(data: data)
        if let info = data["source"] as? [[String: Any]] {
            source = info
                .map { CNLCExpressionParseElement.loadFromData($0) }
        }
    }

}
