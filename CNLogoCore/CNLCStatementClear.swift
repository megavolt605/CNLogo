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
open class CNLCStatementClear: CNLCStatement {
    
    override open var identifier: String {
        return "CLEAR"
    }
    
    override open func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 0 {
            return CNLCBlockPrepareResult.error(block: self, error: .statementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            return program.clear()
        } else {
            return .error(block: self, error: .noProgram)
        }
    }
    
}
