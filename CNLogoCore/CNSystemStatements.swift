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
        parameters.forEach {
            if let desc = try? $0.execute().description {
                CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Print(value: desc), block: self)
            }
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
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = try parameters.first?.execute() {
            if let variable = variableByName(variableName) {
                variable.variableValue = value
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
                return value
            }
        } else {
            if let _ = parentBlock?.variableByName(variableName) {
                throw CNError.VariableAlreadyExists(variableName: variableName)
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: .unknown))
            }
        }
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Step, block: self)
        return .unknown
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
        return res
    }
    
    public init(variableName: String, parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        self.variableName = variableName
        super.init(parameters: parameters, statements: statements, functions: functions)
    }

    required public init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNStatementVar.init(parameters:statements:functions:) has not been implemented")
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
