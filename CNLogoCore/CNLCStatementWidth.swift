//
//  CNLCStatementWidth.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Set player drawing line width
/// Arguments:      Width(Numeric)
public class CNLCStatementWidth: CNLCStatement {
    
    override public var identifier: String {
        return "WIDTH"
    }
    
    override public var description: String {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
        } else {
            return "No program"
        }
    }
    
    override public func prepare() -> CNLCBlockPrepareResult{
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 1 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.player.setWidth(executableParameters.first!.variableValue, fromBlock: self)
        } else {
            return .Error(block: self, error: .NoProgram)
        }
        return result
    }
    
    
}
