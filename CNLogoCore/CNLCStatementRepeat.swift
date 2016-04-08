//
//  CNLCStatementRepeat.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNLCStatementRepeat: CNLCStatement {
    
    override public var identifier: String {
        return "REPEAT"
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
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.StepOut, fromBlock: self)
        }
        return result
    }
    
}
