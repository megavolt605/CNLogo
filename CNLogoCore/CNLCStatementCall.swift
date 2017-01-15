//
//  CNLCStatementCall.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

open class CNLCStatementCall: CNLCStatement {
    
    override open var identifier: String {
        return "CALL"
    }
    
    open var funcName: String
    
    override open var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    /*
     func prepareWithParameters(parameters: [CNExpression]) {
     guard parameters.count == formalParameters.count else {
     throw CNError.InvalidParameterCount(functionName: funcName)
     }
     /*for i in 0..<parameters.count {
     if !(try parameters[i].prepare().isEqualTo(formalParameters[i])) {
     throw CNError.InvalidParameterType(functionName: funcName, parameterIndex: i)
     }
     }*/
     }*/
    
    override open func variableByName(_ name: String) -> CNLCVariable? {
        for v in variables {
            if v.variableName == name {
                return v
            }
        }
        return parentBlock?.variableByName(name)
    }
    
    open override func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let function = functionByName(funcName) {
            function.executableParameters = executableParameters.map { parameter in
                return CNLCVariable(
                    variableName: parameter.variableName,
                    variableValue: parameter.variableValue.execute()
                )
            }
            return function.executeStatements()
        }
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.step, fromBlock: self)
        return result
    }
    
    public init(funcName: String, executableParameters: [CNLCVariable] = []) {
        self.funcName = funcName
        super.init(executableParameters: executableParameters)
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
