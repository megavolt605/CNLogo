//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementForward: CNStatement {
    
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
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown = true
        return .unknown
    }
    
}

class CNStatementTailUp: CNStatement {
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.player.tailDown = false
        return .unknown
    }
    
}

class CNStatementColor: CNStatement {
    
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
    
    override func execute() throws -> CNValue {
        try super.execute()
        program.clear()
        return .unknown
    }
    
}

