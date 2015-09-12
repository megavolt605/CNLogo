//
//  CNWorkflowRepeat.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementRepeat: CNStatement {
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        switch try parameters.first!.execute() {
        case let .int(value):
            for _ in 0..<value {
                try statements.forEach {
                    try $0.execute()
                }
            }
        default: throw NSError(domain: "Int expected", code: 0, userInfo: nil)
        }
        return .unknown
    }
    
}

class CNStatementWhile: CNStatement {

    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        repeat {
            switch try parameters.first!.execute() {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute()
                    }
                } else {
                    break
                }
            default: try throwError()
            }
        } while true
    }
    
}

class CNStatementIf: CNStatement {
    
    var statementsElse: [CNStatement] = []
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        repeat {
            switch try parameters.first!.execute() {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute()
                    }
                } else {
                    try statementsElse.forEach {
                        try $0.execute()
                    }
                }
            default: try throwError()
            }
        } while true
    }
    

    init(parameters: [CNExpression] = [], statements: [CNStatement] = [], statementsElse: [CNStatement] = [], functions: [CNFunction]) {
        self.statementsElse = statementsElse
        super.init(parameters: parameters, statements: statements, functions: functions)
    }

}
