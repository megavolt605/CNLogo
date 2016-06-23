//
//  CNLCFunctions.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNLCFunctionSin: CNLCStatementFunction {

    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
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
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "SIN",
            formalParameters: [CNLCVariable(variableName: "angle", variableValue: .Double(value: 0.0))],
            statements: []
        )
    }

    required public init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }
    
    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }

}

public class CNLCFunctionCos: CNLCStatementFunction {
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
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
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "COS",
            formalParameters: [CNLCVariable(variableName: "angle", variableValue: .Double(value: 0.0))],
            statements: []
        )
    }

    required public init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }

    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }
    
}
