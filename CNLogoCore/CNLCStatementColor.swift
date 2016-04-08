//
//  CNLCStatementColor.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Set player drawing line color
/// Arguments:      New color(Color)
public class CNLCStatementColor: CNLCStatement {
    
    override public var identifier: String {
        return "COLOR"
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
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.player.setColor(executableParameters.first!.variableValue, fromBlock: self)
        } else {
            return .Error(block: self, error: .NoProgram)
        }
        return result
    }
    
}

