//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementPrint: CNStatement {
    
    override func execute() throws -> CNValue {
        try super.execute()
        try parameters.forEach {
            print(try $0.execute().description)
        }
        return .unknown
    }
    
}

class CNStatementVar: CNStatement {
    
    var name: String
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count > 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        if let value = try parameters.first?.execute() {
            if let variable = variableByName(name) {
                variable.value = value
            } else {
                parentBlock?.variables.append(CNVariable(name: name, value: value))
                return value
            }
        } else {
            if let _ = parentBlock?.variableByName(name) {
                throw NSError(domain: "Variable \(name) redeclared", code: 0, userInfo: nil)
            } else {
                parentBlock?.variables.append(CNVariable(name: name, value: .unknown))
            }
        }
        return .unknown
    }
    
    init(name: String, parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        self.name = name
        super.init(parameters: parameters, statements: statements, functions: functions)
    }
    
}

/*
class CNStatementLet: CNStatement {
    
}
*/