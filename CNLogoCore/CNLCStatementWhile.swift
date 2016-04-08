//
//  CNLCStatementWhile.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

public class CNLCStatementWhile: CNLCStatement {
    
    override public var identifier: String {
        return "WHILE"
    }
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }
        
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.StepIn, fromBlock: self)
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
                        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.StepOut, fromBlock: self)
                        break
                    }
                case .Error: return value
                default: return .Error(block: self, error: .BoolValueExpected)
                }
            }
        } while true
    }
    
}
