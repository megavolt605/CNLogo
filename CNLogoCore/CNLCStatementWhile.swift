//
//  CNLCStatementWhile.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

open class CNLCStatementWhile: CNLCStatement {
    
    override open var identifier: String {
        return "WHILE"
    }
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        var result = super.execute(parameters)
        if result.isError { return result }
        
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.stepIn, fromBlock: self)
        repeat {
            if let value = executableParameters.first?.variableValue.execute() {
                switch value {
                case let .bool(value):
                    if value {
                        for statement in statements {
                            result = statement.execute()
                            if result.isError { return result }
                        }
                    } else {
                        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.stepOut, fromBlock: self)
                        break
                    }
                case .error: return value
                default: return .error(block: self, error: .boolValueExpected)
                }
            }
        } while true
    }
    
}
