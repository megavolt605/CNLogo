//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementPrint: CNStatement {
    
    override public var identifier: String {
        return "PRINT"
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Print(value: result.description), fromBlock: self)
        }
        return result
    }
    
}

public class CNStatementVar: CNStatement {
    
    override public var identifier: String {
        return "VAR"
    }
    
    override public var description: String {
        return "\(identifier) \"\(variableName)\" = " + parametersDescription
    }
    
    public var variableName: String
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        let result = super.execute(parameters)
        if result.isError { return result }

        if let value = executableParameters.first?.variableValue.execute() {
            if value.isError { return result }
            if let variable = variableByName(variableName) {
                variable.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            if let _ = parentBlock?.variableByName(variableName) {
                return CNValue.error(block: self, error: .VariableAlreadyExists(variableName: variableName))
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: .unknown))
            }
        }
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        return result
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
        return res
    }
    
    public init(variableName: String, executableParameters: [CNVariable]) {
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
    
}
