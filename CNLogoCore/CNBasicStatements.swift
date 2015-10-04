//
//  CNBasicStatements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementForward: CNStatement {
    
    override public var identifier: String {
        return "FORWARD"
    }
    
    override public var description: String {
        return super.description + (CNEnviroment.defaultEnviroment.currentProgram.player.state.scale == 1.0 ? "" : ", scale = \(CNEnviroment.defaultEnviroment.currentProgram.player.state.scale)")
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.moveForward(parameters.first!, fromBlock: self)
        return .unknown
    }

}

public class CNStatementBackward: CNStatement {
    
    override public var identifier: String {
        return "BACKWARD"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.moveBackward(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementRotate: CNStatement {
    
    override public var identifier: String {
        return "ROTATE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.rotate(parameters.first!, fromBlock: self)
        return .unknown
    }

}

public class CNStatementTailDown: CNStatement {
    
    override public var identifier: String {
        return "TAIL DOWN"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.player.tailDown(true, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementTailUp: CNStatement {
    
    override public var identifier: String {
        return "TAIL UP"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.player.tailDown(false, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementColor: CNStatement {
    
    override public var identifier: String {
        return "COLOR"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.setColor(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementWidth: CNStatement {
    
    override public var identifier: String {
        return "WIDTH"
    }
    
    override public var description: String {
        return super.description + (CNEnviroment.defaultEnviroment.currentProgram.player.state.scale == 1.0 ? "" : ", scale = \(CNEnviroment.defaultEnviroment.currentProgram.player.state.scale)")
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.setWidth(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

public class CNStatementClear: CNStatement {
    
    override public var identifier: String {
        return "CLEAR"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram.clear()
        return .unknown
    }
    
}

public class CNStatementScale: CNStatement {
    
    override public var identifier: String {
        return "SCALE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram.player.setScale(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

