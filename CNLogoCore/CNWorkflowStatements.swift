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
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepIn, fromBlock: self)
        switch try parameters.first!.value.execute() {
        case let .int(value):
            for _ in 1..<value {
                try statements.forEach {
                    try $0.execute()
                }
            }
        default: throw CNError.IntValueExpected
        }
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepOut, fromBlock: self)
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
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepIn, fromBlock: self)
        repeat {
            switch try parameters.first!.value.execute() {
            case let .bool(value):
                if value {
                    try statements.forEach {
                        try $0.execute()
                    }
                } else {
                    CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepOut, fromBlock: self)
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
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        switch try parameters.first!.value.execute() {
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

    convenience init(statements: [CNStatement] = [], statementsElse: [CNStatement] = []) {
        self.init(statements: statements)
        self.statementsElse = statementsElse
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
