//
//  CNBasicFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNForward: CNStatement {
    
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

class CNBackward: CNStatement {
    
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

class CNRotate: CNStatement {
    
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

class CNTailDown: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        program.player.tailDown = true
        return .unknown
    }
    
}

class CNTailUp: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        program.player.tailDown = false
        return .unknown
    }
    
}
