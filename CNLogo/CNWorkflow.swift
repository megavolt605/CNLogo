//
//  CNWorkflowRepeat.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementRepeat: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        switch try parameters.first!.execute(inBlock) {
        case let .int(value):
            for _ in 0..<value {
                try statements.forEach {
                    try $0.execute(inBlock)
                }
            }
        default: throw NSError(domain: "Int expected", code: 0, userInfo: nil)
        }
        return .unknown
    }
    
}

class CNStatementWhile: CNStatement {

    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        repeat {
            switch try parameters.first!.execute(inBlock) {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute(inBlock)
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
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        repeat {
            switch try parameters.first!.execute(inBlock) {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute(inBlock)
                    }
                } else {
                    try statementsElse.forEach {
                        try $0.execute(inBlock)
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
