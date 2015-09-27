//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementForward: CNStatement {
    
    override var name: String {
        return "FORWARD"
    }
    
    override var description: String {
        return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveForward(parameters.first!, fromBlock: self)
        return .unknown
    }

}

class CNStatementBackward: CNStatement {
    
    override var name: String {
        return "BACKWARD"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveBackward(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

class CNStatementRotate: CNStatement {
    
    override var name: String {
        return "ROTATE"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.rotate(parameters.first!, fromBlock: self)
        return .unknown
    }

}

class CNStatementTailDown: CNStatement {
    
    override var name: String {
        return "TAIL DOWN"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(true, fromBlock: self)
        return .unknown
    }
    
}

class CNStatementTailUp: CNStatement {
    
    override var name: String {
        return "TAIL UP"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(false, fromBlock: self)
        return .unknown
    }
    
}

class CNStatementColor: CNStatement {
    
    override var name: String {
        return "COLOR"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setColor(parameters.first!, fromBlock: self)
        return .unknown
    }
    
}

class CNStatementWidth: CNStatement {
    
    override var name: String {
        return "WIDTH"
    }
    
    override var description: String {
        return super.description + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setWidth(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

class CNStatementClear: CNStatement {
    
    override var name: String {
        return "CLEAR"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.clear()
        return .unknown
    }
    
}

class CNStatementScale: CNStatement {
    
    override var name: String {
        return "SCALE"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setScale(parameters.first!, fromBlock: self)
        return .unknown
    }
    
    
}

