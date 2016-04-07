//
//  CNEmbedFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNFunctionSin: CNStatementFunction {

    override func executeWithParameters(parameters: [CNExpression]) -> CNValue {
        if let value = parameters.first?.execute() {
            switch value {
            case let .double(doubleValue): return CNValue.double(value: sin(doubleValue))
            case let .int(intValue): return CNValue.double(value: sin(Double(intValue)))
            case let .string(stringValue): return CNValue.double(value: sin(stringValue.doubleValue))
            case .error: return value
            default: break
            }
        }
        return super.executeWithParameters(parameters)
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
            formalParameters: [CNVariable(variableName: "angle", variableValue: CNValue.double(value: 0.0))],
            statements: []
        )
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }

}

public class CNFunctionCos: CNStatementFunction {
    
    override func executeWithParameters(parameters: [CNExpression]) -> CNValue {
        if let value = parameters.first?.execute() {
            switch value {
            case let .double(doubleValue): return CNValue.double(value: cos(doubleValue))
            case let .int(intValue): return CNValue.double(value: cos(Double(intValue)))
            case let .string(stringValue): return CNValue.double(value: cos(stringValue.doubleValue))
            case .error: return value
            default: break
            }
        }
        return super.executeWithParameters(parameters)
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
            formalParameters: [CNVariable(variableName: "angle", variableValue: CNValue.double(value: 0.0))],
            statements: []
        )
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }

}
