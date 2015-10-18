//
//  CNBasicStatements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

/// Description:    Move player forward from current position, with current angle
///                 If tail is down, draw line with current color and width
/// Arguments:      Distance(Numeric)
public class CNStatementForward: CNStatement {
    
    override public var identifier: String {
        return "FORWARD"
    }
    
    override public var description: String {
        if let program = CNEnviroment.defaultEnviroment.currentProgram {
            return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
        } else {
            return "No program"
        }
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }

}

/// Description:    Move player backward from current position, with current angle
///                 If tail is down, draw line with current color and width
/// Arguments:      Distance(Numeric)
public class CNStatementBackward: CNStatement {
    
    override public var identifier: String {
        return "BACKWARD"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.moveBackward(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }
    
}

/// Description:    Move player forward from current position, with current angle
///                 Nothing is drawn
///                 Preserve tail state
/// Arguments:      Distance(Numeric)
public class CNStatementMove: CNStatementForward {
    
    override public var identifier: String {
        return "MOVE"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let player = CNEnviroment.defaultEnviroment.currentProgram?.player {
            let tailDown = player.state.tailDown
            if tailDown {
                player.tailDown(false, fromBlock: self)
            }
            try player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
            if tailDown {
                player.tailDown(true, fromBlock: self)
            }
        }
        return .unknown
    }
    
}

/// Description:    Move player forward from current position, with current angle
///                 Movement is drawn as line with current color and width
///                 Preserve tail state
/// Arguments:      Distance(Numeric)
public class CNStatementDRAW: CNStatementForward {
    
    override public var identifier: String {
        return "DRAW"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let player = CNEnviroment.defaultEnviroment.currentProgram?.player {
            let tailDown = player.state.tailDown
            if !tailDown {
                player.tailDown(true, fromBlock: self)
            }
            try player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
            if !tailDown {
                player.tailDown(false, fromBlock: self)
            }
        }
        return .unknown
    }
    
}

/// Description:    Rotate player by argument
/// Arguments:      Angle delta(Double), in degrees. Positive - clockwise
public class CNStatementRotate: CNStatement {
    
    override public var identifier: String {
        return "ROTATE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.rotate(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }

}

/// Description:    Set tail state to Down (FORWARD and BACKWARD statements will draw)
/// Arguments:      nope
public class CNStatementTailDown: CNStatement {
    
    override public var identifier: String {
        return "TAIL DOWN"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram?.player.tailDown(true, fromBlock: self)
        return .unknown
    }
    
}

/// Description:    Set tail state to Up (no drawing with FORWARD and BACKWARD statements)
/// Arguments:      nope
public class CNStatementTailUp: CNStatement {
    
    override public var identifier: String {
        return "TAIL UP"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram?.player.tailDown(false, fromBlock: self)
        return .unknown
    }
    
}

/// Description:    Set player drawing line color
/// Arguments:      New color(Color)
public class CNStatementColor: CNStatement {
    
    override public var identifier: String {
        return "COLOR"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.setColor(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }
    
}

/// Description:    Set player drawing line width
/// Arguments:      Width(Numeric)
public class CNStatementWidth: CNStatement {
    
    override public var identifier: String {
        return "WIDTH"
    }
    
    override public var description: String {
        if let program = CNEnviroment.defaultEnviroment.currentProgram {
            return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
        } else {
            return "No program"
        }
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.setWidth(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }
    
    
}

/// Description:    Clears drawing field, return player to initial state
/// Arguments:      nope
public class CNStatementClear: CNStatement {
    
    override public var identifier: String {
        return "CLEAR"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        CNEnviroment.defaultEnviroment.currentProgram?.clear()
        return .unknown
    }
    
}

/// Description:    Set player drawing scale (affecs to all movement distances, drawing line width)
/// Arguments:      New scale(Numeric)
public class CNStatementScale: CNStatement {
    
    override public var identifier: String {
        return "SCALE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try CNEnviroment.defaultEnviroment.currentProgram?.player.setScale(executableParameters.first!.variableValue, fromBlock: self)
        return .unknown
    }
    
    
}

