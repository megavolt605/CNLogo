//
//  CNLCSystemFunctions.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNLCStatementPrint: CNLCStatement {
    
    override public var identifier: String {
        return "PRINT"
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.Print(value: result.description), fromBlock: self)
        }
        return result
    }
    
}

public class CNLCStatementVar: CNLCStatement {
    
    override public var identifier: String {
        return "VAR"
    }
    
    override public var description: String {
        return "\(identifier) \"\(variableName)\" = " + parametersDescription
    }
    
    public var variableName: String
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = super.execute(parameters)
        if result.isError { return result }

        if let value = executableParameters.first?.variableValue.execute() {
            if value.isError { return result }
            if let variable = variableByName(variableName) {
                variable.variableValue = CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNLCVariable(variableName: variableName, variableValue: value))
            }
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            if let _ = parentBlock?.variableByName(variableName) {
                return .Error(block: self, error: .VariableAlreadyExists(variableName: variableName))
            } else {
                parentBlock?.variables.append(CNLCVariable(variableName: variableName, variableValue: .Unknown))
            }
        }
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.Step, fromBlock: self)
        return result
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
        return res
    }
    
    public init(variableName: String, executableParameters: [CNLCVariable]) {
        self.variableName = variableName
        super.init(executableParameters: executableParameters)
    }

    required public init(data: [String : AnyObject]) {
        if let variableName = data["variable-name"] as? String {
            self.variableName = variableName
            super.init(data: data)
        } else {
            fatalError("CNStatementVar.init(data:) variable name not found")
        }
    }
    
    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }
    
}
