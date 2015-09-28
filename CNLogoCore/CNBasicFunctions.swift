//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementForward: CNStatement {
    
    override public var name: String {
        return "FORWARD"
    }
    
    override public var description: String {
        return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveForward(parameters.first!, fromBlock: self)
        return .unknown
    }

}

public class CNStatementBackward: CNStatement {
    
    override public var name: String {
        return "BACKWARD"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveBackward(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementRotate: CNStatement {
    
    override public var name: String {
        return "ROTATE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.rotate(parameters.first!, fromBlock: self)
        return .unknown
    }

}

public class CNStatementTailDown: CNStatement {
    
    override public var name: String {
        return "TAIL DOWN"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(true, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementTailUp: CNStatement {
    
    override public var name: String {
        return "TAIL UP"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(false, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementColor: CNStatement {
    
    override public var name: String {
        return "COLOR"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.setColor(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

public class CNStatementWidth: CNStatement {
    
    override public var name: String {
        return "WIDTH"
    }
    
    override public var description: String {
        return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.setWidth(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

public class CNStatementClear: CNStatement {
    
    override public var name: String {
        return "CLEAR"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        program.clear()
        return .unknown
    }
    
}

public class CNStatementScale: CNStatement {
    
    override public var name: String {
        return "SCALE"
    }
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try program.player.setScale(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

