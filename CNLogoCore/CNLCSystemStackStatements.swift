//
//  CNLCSystemStackStatements.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNLCStatementPush: CNLCStatement {
    
    override public var identifier: String {
        return "PUSH"
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        var result = super.execute(parameters)
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            parentBlock?.valueStack.push(result)
        }
        return .Unknown
    }
    
}

public class CNLCStatementPop: CNLCStatement {
    
    override public var identifier: String {
        return "POP"
    }
    
    public var variableName: String
    
    func popValue() -> CNLCValue? {
        return parentBlock?.valueStack.pop()
    }
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }

        if executableParameters.count != 0 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let value = popValue() {
            if let variable = variableByName(variableName) {
                variable.variableValue = CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNLCVariable(variableName: variableName, variableValue: value))
            }
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            return .Error(block: self, error: .InvalidValue)
        }
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
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
    
}

public class CNLCStatementGlobalPush: CNLCStatementPush {
    
    override public var identifier: String {
        return "GPUSH"
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
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

public class CNLCStatementGlobalPop: CNLCStatementPop {
    
    override public var identifier: String {
        return "GPOP"
    }
    
    override func popValue() -> CNLCValue? {
        return CNLCEnviroment.defaultEnviroment.currentProgram?.globalStack.pop()
    }
}


