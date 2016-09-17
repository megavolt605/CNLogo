//
//  CNLCStatementRotate.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Rotate player by argument
/// Arguments:      Angle delta(Double), in degrees. Positive - clockwise
open class CNLCStatementRotate: CNLCStatement {
    
    override open var identifier: String {
        return "ROTATE"
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
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.player.rotate(executableParameters.first!.variableValue, fromBlock: self)
        } else {
            return .error(block: self, error: .noProgram)
        }
        return result
    }
    
}

