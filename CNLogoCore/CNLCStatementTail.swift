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
open class CNLCStatementTailDown: CNLCStatement {
    
    override open var identifier: String {
        return "TAIL DOWN"
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
            return program.player.tailDown(true, fromBlock: self)
        } else {
            return .error(block: self, error: .noProgram)
        }
    }
    
}

/// Description:    Set tail state to Up (no drawing with FORWARD and BACKWARD statements)
/// Arguments:      nope
open class CNLCStatementTailUp: CNLCStatement {
    
    override open var identifier: String {
        return "TAIL UP"
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
            return program.player.tailDown(false, fromBlock: self)
        } else {
            return .error(block: self, error: .noProgram)
        }
    }
    
    override required public init() {
        super.init()
    }
    
    public required init(data: [String : Any]) {
        fatalError("init(data:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }
    
    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
}


