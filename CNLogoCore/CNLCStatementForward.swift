//
//  CNLCStatementForward.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Move player forward from current position, with current angle
///                 If tail is down, draw line with current color and width
/// Arguments:      Distance(Numeric)
open class CNLCStatementForward: CNLCStatement {
    
    override open var identifier: String {
        return "FORWARD"
    }
    
    override open var description: String {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
        } else {
            return "No program"
        }
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
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram{
            return program.player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
        } else {
            return .error(block: self, error: .noProgram)
        }
    }
    
}
