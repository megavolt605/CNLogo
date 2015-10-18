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
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try executableParameters.forEach {
            let desc = try $0.variableValue.execute().description
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Print(value: desc), fromBlock: self)
        }
        return .unknown
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
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = try executableParameters.first?.variableValue.execute() {
            if let variable = variableByName(variableName) {
                variable.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            if let _ = parentBlock?.variableByName(variableName) {
                throw CNError.VariableAlreadyExists(variableName: variableName)
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: .unknown))
            }
        }
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        return .unknown
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
