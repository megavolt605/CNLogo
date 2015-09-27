//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementPrint: CNStatement {
    
    override var name: String {
        return "PRINT"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        parameters.forEach {
            if let desc = try? $0.execute().description {
                program.executionHistory.append(CNExecutionHistoryItemType.Print(value: desc), block: self)
            }
        }
        return .unknown
    }
    
}

class CNStatementVar: CNStatement {
    
    override var name: String {
        return "VAR"
    }
    
    override var description: String {
        return "\(name) \"\(varName)\" = " + parametersDescription
    }
    
    var varName: String
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count > 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
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
        program.executionHistory.append(CNExecutionHistoryItemType.Step, block: self)
        return .unknown
    }
    
    init(name: String, parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        self.varName = name
        super.init(parameters: parameters, statements: statements, functions: functions)
    }
    
}
