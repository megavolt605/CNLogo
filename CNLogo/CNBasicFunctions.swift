//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementForward: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try program.player.moveForward(parameters.first!, inBlock: inBlock)
        return .unknown
    }

}

class CNStatementBackward: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try program.player.moveBackward(parameters.first!, inBlock: inBlock)
        return .unknown
    }
    
}

class CNStatementRotate: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try program.player.rotate(parameters.first!, inBlock: inBlock)
        return .unknown
    }

}

class CNStatementTailDown: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        program.player.tailDown = true
        return .unknown
    }
    
}

class CNStatementTailUp: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        program.player.tailDown = false
        return .unknown
    }
    
}


class CNStatementColor: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try program.player.setColor(parameters.first!, inBlock: inBlock)
        return .unknown
    }
    
    
}

class CNStatementWidth: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try program.player.setWidth(parameters.first!, inBlock: inBlock)
        return .unknown
    }
    
    
}
