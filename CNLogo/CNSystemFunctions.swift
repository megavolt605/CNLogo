//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementPrint: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try parameters.forEach {
            print(try $0.execute(inBlock).description)
        }
        return .unknown
    }
    
}

class CNStatementVar: CNStatement {
    
    var name: String
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count > 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        if let value = try parameters.first?.execute(inBlock) {
            if let variable = inBlock.variableByName(name) {
                variable.value = value
            } else {
                parentBlock?.variables.append(CNVariable(name: name, value: value))
            }
        } else {
            if let _ = inBlock.variableByName(name) {
                throw NSError(domain: "Variable \(name) redelared", code: 0, userInfo: nil)
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