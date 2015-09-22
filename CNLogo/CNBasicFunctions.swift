//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementForward: CNStatement {
    
    override var description: String {
        return "FORWARD \(parametersDescription)" + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveForward(parameters.first!)
        return .unknown
    }

}

class CNStatementBackward: CNStatement {
    
    override var description: String {
        return "BACKWARD \(parametersDescription)"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.moveBackward(parameters.first!)
        return .unknown
    }
    
}

class CNStatementRotate: CNStatement {
    
    override var description: String {
        return "ROTATE \(parametersDescription)"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.rotate(parameters.first!)
        return .unknown
    }

}

class CNStatementTailDown: CNStatement {
    
    override var description: String {
        return "TAIL DOWN"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(true)
        return .unknown
    }
    
}

class CNStatementTailUp: CNStatement {
    
    override var description: String {
        return "TAIL UP"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown(false)
        return .unknown
    }
    
}

class CNStatementColor: CNStatement {
    
    override var description: String {
        return "COLOR \(parametersDescription)"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setColor(parameters.first!)
        return .unknown
    }
    
}

class CNStatementWidth: CNStatement {
    
    override var description: String {
        return "WIDTH \(parametersDescription)" + (program.player.state.scale == 1.0 ? "" : ", scale = \(program.player.state.scale)")
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setWidth(parameters.first!)
        return .unknown
    }
    
    
}

class CNStatementClear: CNStatement {
    
    override var description: String {
        return "CLEAR"
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.clear()
        return .unknown
    }
    
}

class CNStatementScale: CNStatement {
    
    override var description: String {
        return "SCALE \(parametersDescription)"
    }
    
    override func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute() throws -> CNValue {
        try super.execute()
        try program.player.setScale(parameters.first!)
        return .unknown
    }
    
    
}

