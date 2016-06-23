//
//  CNLCStatementIf.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

public class CNLCStatementIf: CNLCStatement {
    
    override public var identifier: String {
        return "IF"
    }
    
    var statementsElse: [CNLCStatement] = []
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    public override func executeStatements() -> CNLCValue {
        ///
        return .Unknown
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }
        
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.Step, fromBlock: self)
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
    
    public init(executableParameters: [CNLCVariable], statements: [CNLCStatement] = [], statementsElse: [CNLCStatement] = []) {
        super.init(executableParameters: executableParameters, statements: statements)
        self.statementsElse = statementsElse
    }
    
    required public init(data: [String : AnyObject]) {
        super.init(data: data)
        if let info = data["statements-else"] as? [[String: AnyObject]] {
            statementsElse = info.map { item in return CNLCStatement(data: item) }
        } else {
            statementsElse = []
        }
    }
    
    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }
    
}
