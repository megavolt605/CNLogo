//
//  CNLCStatementRepeat.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

open class CNLCStatementRepeat: CNLCStatement {
    
    override open var identifier: String {
        return "REPEAT"
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
        if let value = executableParameters.first?.variableValue.execute() {
            switch value {
            case let .int(value):
                for _ in 1..<value {
                    for statement in statements {
                        result = statement.execute()
                        if result.isError { return result }
                    }
                }
            case .error: return value
            default: return .error(block: self, error: .intValueExpected)
            }
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.stepOut, fromBlock: self)
        }
        return result
    }
    
}
