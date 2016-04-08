//
//  CNLCStatementTail.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Set tail state to Down (FORWARD and BACKWARD statements will draw)
/// Arguments:      nope
public class CNLCStatementTailDown: CNLCStatement {
    
    override public var identifier: String {
        return "TAIL DOWN"
    }
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        
        if executableParameters.count != 0 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        let result = super.execute(parameters)
        if result.isError { return result }
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.player.tailDown(true, fromBlock: self)
        } else {
            return .Error(block: self, error: .NoProgram)
        }
        return result
    }
    
}

/// Description:    Set tail state to Up (no drawing with FORWARD and BACKWARD statements)
/// Arguments:      nope
public class CNLCStatementTailUp: CNLCStatement {
    
    override public var identifier: String {
        return "TAIL UP"
    }
    
    override public func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }
        if executableParameters.count != 0 {
            return CNLCBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        let result = super.execute(parameters)
        if result.isError { return result }
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.player.tailDown(false, fromBlock: self)
        } else {
            return .Error(block: self, error: .NoProgram)
        }
        return result
    }
    
}


