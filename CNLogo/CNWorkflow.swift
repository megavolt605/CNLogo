//
//  CNWorkflowRepeat.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementRepeat: CNStatement {
    
    override var name: String {
        return "REPEAT"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.executionHistory.append(CNExecutionHistoryItemType.StepIn, block: self)
        switch try parameters.first!.execute() {
        case let .int(value):
            for _ in 1...value {
                try statements.forEach {
                    try $0.execute()
                }
            }
        default: throw NSError(domain: "Int expected", code: 0, userInfo: nil)
        }
        program.executionHistory.append(CNExecutionHistoryItemType.StepOut, block: self)
        return .unknown
    }
    
}

class CNStatementWhile: CNStatement {

    override var name: String {
        return "WHILE"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.executionHistory.append(CNExecutionHistoryItemType.StepIn, block: self)
        repeat {
            switch try parameters.first!.execute() {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute()
                    }
                } else {
                    program.executionHistory.append(CNExecutionHistoryItemType.StepOut, block: self)
                    break
                }
            default: try throwError()
            }
        } while true
    }
    
}

class CNStatementIf: CNStatement {

    override var name: String {
        return "IF"
    }
    
    var statementsElse: [CNStatement] = []
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.executionHistory.append(CNExecutionHistoryItemType.Step, block: self)
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
        return .unknown
    }
    

    init(parameters: [CNExpression] = [], statements: [CNStatement] = [], statementsElse: [CNStatement] = [], functions: [CNFunction]) {
        self.statementsElse = statementsElse
        super.init(parameters: parameters, statements: statements, functions: functions)
    }

}
