//
//  CNEmbedFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNFunctionSin: CNStatementFunction {

    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        if let value = parameters.first?.execute(parameters) {
            switch value {
            case let .Double(doubleValue): return .Double(value: sin(doubleValue))
            case let .Int(intValue): return .Double(value: sin(Double(intValue)))
            case let .String(stringValue): return .Double(value: sin(stringValue.doubleValue))
            case .Error: return value
            default: break
            }
        }
        return super.execute(parameters)
    }
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "SIN",
            formalParameters: [CNVariable(variableName: "angle", variableValue: .Double(value: 0.0))],
            statements: []
        )
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }

}

public class CNFunctionCos: CNStatementFunction {
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        if let value = parameters.first?.execute(parameters) {
            switch value {
            case let .Double(doubleValue): return .Double(value: cos(doubleValue))
            case let .Int(intValue): return .Double(value: cos(Double(intValue)))
            case let .String(stringValue): return .Double(value: cos(stringValue.doubleValue))
            case .Error: return value
            default: break
            }
        }
        return super.execute(parameters)
    }
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "COS",
            formalParameters: [CNVariable(variableName: "angle", variableValue: .Double(value: 0.0))],
            statements: []
        )
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }

}
