//
//  CNLCExpression.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNLCExpression: CNLCBlock {
    
    public var source: [CNLCExpressionParseElement]
    
    override public var identifier: String {
        return "EXPR"
    }
    
    override public var description: String {
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
    
    private var preparedSource: [CNLCExpressionParseElement] = []
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        var operatorStack = CNLCStack<CNLCExpressionParseElement>()
        preparedSource = []
        for element in source {
            if CNLCExpressionParseElement.operators.contains({ $0.isEqualTo(element) }) {
                // operator
                repeat {
                    if let oper = operatorStack.peek() {
                        let c1 = ((element.associativity == .Right) && (element.weight < oper.weight))
                        let c2 = ((element.associativity == .Left) && (element.weight <= oper.weight))
                        if CNLCExpressionParseElement.operators.contains({ $0.isEqualTo(oper) }) && (c1 || c2) {
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
                            if oper.isEqualTo(CNLCExpressionParseElement.BracketOpen) {
                                break
                            }
                            preparedSource.append(oper)
                        } else {
                            return CNLCBlockPrepareResult.Error(block: self, error: .InvalidExpression)
                        }
                    } while true
                default:
                    return CNLCBlockPrepareResult.Error(block: self, error: .InvalidExpression)
                }
            }
        }
        while operatorStack.count > 0 {
            preparedSource.append(operatorStack.pop()!)
        }
        //preparedSource = preparedSource.reverse()
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }
        
        var resultStack = CNLCStack<CNLCExpressionParseElement>()
        for element in preparedSource {
            if CNLCExpressionParseElement.operators.contains({ $0.isEqualTo(element) }) {
                // operator
                switch element.kind {
                case .Infix:
                    let left = resultStack.pop()!
                    let right = resultStack.pop()!
                    let value = element.getValue(left, right, self)
                    if value.isError { return value.value(self) }
                    resultStack.push(value)
                default: return .Unknown
                }
            } else {
                resultStack.push(element)
            }
            
        }
        
        if let finalResult = resultStack.pop() {
            return finalResult.value(self)
        } else {
            return .Error(block: self, error: .InvalidExpression)
        }
    }

    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["source"] = source.map { $0.store() }
        return res
    }

    public init(source: [CNLCExpressionParseElement]) {
        self.source = source
        super.init()
    }
    
    public required init(data: [String: AnyObject]) {
        source = []
        super.init(data: data)
        if let info = data["source"] as? [[String: AnyObject]] {
            source = info.map { item in return CNLCExpressionParseElement.loadFromData(item) }
        }
    }

}