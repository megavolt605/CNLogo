//
//  CNLCFunctions.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

open class CNLCFunctionSin: CNLCStatementFunction {

    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        if let value = parameters.first?.execute(parameters) {
            switch value {
            case let .double(doubleValue): return .double(value: sin(doubleValue))
            case let .int(intValue): return .double(value: sin(Double(intValue)))
            case let .string(stringValue): return .double(value: sin(stringValue.doubleValue))
            case .error: return value
            default: break
            }
        }
        return super.execute(parameters)
    }
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "SIN",
            formalParameters: [CNLCVariable(variableName: "angle", variableValue: .double(value: 0.0))],
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
    
    public required init(data: [String : Any]) {
        fatalError("init(data:) has not been implemented")
    }

}

open class CNLCFunctionCos: CNLCStatementFunction {
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        if let value = parameters.first?.execute(parameters) {
            switch value {
            case let .double(doubleValue): return .double(value: cos(doubleValue))
            case let .int(intValue): return .double(value: cos(Double(intValue)))
            case let .string(stringValue): return .double(value: cos(stringValue.doubleValue))
            case .error: return value
            default: break
            }
        }
        return super.execute(parameters)
    }
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }

    init() {
        super.init(
            funcName: "COS",
            formalParameters: [CNLCVariable(variableName: "angle", variableValue: .double(value: 0.0))],
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
    
    public required init(data: [String : Any]) {
        fatalError("init(data:) has not been implemented")
    }
    
}
