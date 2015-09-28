//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementPrint: CNStatement {
    
    override public var name: String {
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
    
    override public var name: String {
        return "VAR"
    }
    
    override public var description: String {
        return "\(name) \"\(varName)\" = " + parametersDescription
    }
    
    public var varName: String
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count > 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = try parameters.first?.execute() {
            if let variable = variableByName(varName) {
                variable.value = value
            } else {
                parentBlock?.variables.append(CNVariable(name: varName, value: value))
                return value
            }
        } else {
            if let _ = parentBlock?.variableByName(varName) {
                throw NSError(domain: "Variable \(varName) redeclared", code: 0, userInfo: nil)
            } else {
                parentBlock?.variables.append(CNVariable(name: varName, value: .unknown))
            }
        }
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Step, block: self)
        return .unknown
    }
    
    public init(name: String, parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        self.varName = name
        super.init(parameters: parameters, statements: statements, functions: functions)
    }
    
}
