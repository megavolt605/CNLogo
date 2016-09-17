//
//  CNLCStatementIf.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

open class CNLCStatementIf: CNLCStatement {
    
    override open var identifier: String {
        return "IF"
    }
    
    var statementsElse: [CNLCStatement] = []
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    open override func executeStatements() -> CNLCValue {
        ///
        return .unknown
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }
        
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.step, fromBlock: self)
        if let value = executableParameters.first?.variableValue.execute() {
            switch value {
            case let .bool(condition):
                let statementsToExecute = condition ? statements : statementsElse
                for statement in statementsToExecute {
                    result = statement.execute()
                    if result.isError { return result }
                }
            default: return .error(block: self, error: .boolValueExpected)
            }
        }
        return result
    }
    
    override open func store() -> [String: Any] {
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
        if let info = data["statements-else"] as? [[String: Any]] {
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
        super.init(executableParameters: executableParameters, statements: statements)
    }
    
    public required init(data: [String : Any]) {
        fatalError("init(data:) has not been implemented")
    }
    
}
