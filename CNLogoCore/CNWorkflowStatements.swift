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
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepIn, fromBlock: self)
        if let value = executableParameters.first?.variableValue.execute() {
            switch value {
            case let .Int(value):
                for _ in 1..<value {
                    for statement in statements {
                        result = statement.execute()
                        if result.isError { return result }
                    }
                }
            case .Error: return value
            default: return .Error(block: self, error: .IntValueExpected)
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepOut, fromBlock: self)
        }
        return result
    }
    
}

public class CNStatementWhile: CNStatement {

    override public var identifier: String {
        return "WHILE"
    }
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepIn, fromBlock: self)
        repeat {
            if let value = executableParameters.first?.variableValue.execute() {
                switch value {
                case let .Bool(value):
                    if value {
                        for statement in statements {
                            result = statement.execute()
                            if result.isError { return result }
                        }
                    } else {
                        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.StepOut, fromBlock: self)
                        break
                    }
                case .Error: return value
                default: return .Error(block: self, error: .BoolValueExpected)
                }
            }
        } while true
    }
    
}

public class CNStatementIf: CNStatement {

    override public var identifier: String {
        return "IF"
    }
    
    var statementsElse: [CNStatement] = []
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }

        if executableParameters.count != 1 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    public override func executeStatements() -> CNValue {
        ///
        return .Unknown
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        var result = super.execute(parameters)
        if result.isError { return result }

        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        if let value = executableParameters.first?.variableValue.execute() {
            switch value {
            case let .Bool(condition):
                let statementsToExecute = condition ? statements : statementsElse
                for statement in statementsToExecute {
                    result = statement.execute()
                    if result.isError { return result }
                }
            default: return .Error(block: self, error: .BoolValueExpected)
            }
        }
        return result
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["statement-else"] = statementsElse.map { $0.store() }
        return res
    }

    public init(executableParameters: [CNVariable], statements: [CNStatement] = [], statementsElse: [CNStatement] = []) {
        super.init(executableParameters: executableParameters, statements: statements)
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
