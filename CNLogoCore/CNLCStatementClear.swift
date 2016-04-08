//
//  CNLCStatementClear.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Clears drawing field, return player to initial state
/// Arguments:      nope
public class CNLCStatementClear: CNLCStatement {
    
    override public var identifier: String {
        return "CLEAR"
    }
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 0 {
            CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.clear()
        } else {
            return .Error(block: self, error: .NoProgram)
        }
        return result
    }
    
}
