//
//  CNLCSystemStackStatements.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

open class CNLCStatementPush: CNLCStatement {
    
    override open var identifier: String {
        return "PUSH"
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        
        var result = super.execute(parameters)
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            parentBlock?.valueStack.push(result)
        }
        return .unknown
    }
    
}

open class CNLCStatementPop: CNLCStatement {
    
    override open var identifier: String {
        return "POP"
    }
    
    open var variableName: String
    
    func popValue() -> CNLCValue? {
        return parentBlock?.valueStack.pop()
    }
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }

        if executableParameters.count != 0 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let value = popValue() {
            if let variable = variableByName(variableName) {
                variable.variableValue = CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNLCVariable(variableName: variableName, variableValue: value))
            }
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.step, fromBlock: self)
            return value
        } else {
            return .error(block: self, error: .invalidValue)
        }
    }
    
    override open func store() -> [String: Any] {
        var res = super.store()
        res["variable-name"] = variableName as AnyObject?
        return res
    }
    
    required public init(data: [String : AnyObject]) {
        if let variableName = data["variable-name"] as? String {
            self.variableName = variableName
            super.init(data: data)
        } else {
            fatalError("CNStatementVar.init(data:) variable name not found")
        }
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

open class CNLCStatementGlobalPush: CNLCStatementPush {
    
    override open var identifier: String {
        return "GPUSH"
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            CNLCEnviroment.defaultEnviroment.currentProgram?.globalStack.push(result)
        }
        return result
    }
    
}

open class CNLCStatementGlobalPop: CNLCStatementPop {
    
    override open var identifier: String {
        return "GPOP"
    }
    
    override func popValue() -> CNLCValue? {
        return CNLCEnviroment.defaultEnviroment.currentProgram?.globalStack.pop()
    }
}


