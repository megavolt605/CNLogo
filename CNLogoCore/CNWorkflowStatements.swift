//
//  CNWorkflowStatements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementRepeat: CNStatement {
    
    override public var identifier: String {
        return "REPEAT"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.StepIn, block: self)
        switch try parameters.first!.execute() {
        case let .int(value):
            for _ in 1..<value {
                try statements.forEach {
                    try $0.execute()
                }
            }
        default: throw CNError.IntValueExpected
        }
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.StepOut, block: self)
        return .unknown
    }
    
}

public class CNStatementWhile: CNStatement {

    override public var identifier: String {
        return "WHILE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.StepIn, block: self)
        repeat {
            switch try parameters.first!.execute() {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute()
                    }
                } else {
                    CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.StepOut, block: self)
                    break
                }
            default: throw CNError.BoolValueExpected
            }
        } while true
    }
    
}

public class CNStatementIf: CNStatement {

    override public var identifier: String {
        return "IF"
    }
    
    var statementsElse: [CNStatement] = []
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Step, block: self)
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
        default: throw CNError.BoolValueExpected
        }
        return .unknown
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["statement-else"] = statementsElse.map { $0.store() }
        return res
    }

    init(parameters: [CNExpression] = [], statements: [CNStatement] = [], statementsElse: [CNStatement] = [], functions: [CNFunction]) {
        self.statementsElse = statementsElse
        super.init(parameters: parameters, statements: statements, functions: functions)
    }

    required public init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNStatementIf.init(parameters:statements:functions:) has not been implemented")
    }

    required public init(data: [String : AnyObject]) {
        super.init(data: data)
        if let info = data["statements-else"] as? [[String: AnyObject]] {
            statementsElse = info.map { item in return CNStatement(data: item) }
        } else {
            statementsElse = []
        }
    }

}
