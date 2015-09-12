//
//  CNProgram.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics

var program = CNProgram(parameters: [])

protocol CNPlayerDelegate {
    
    func player(player: CNPlayer, willMoveFromPosition position: CGPoint)
    func player(player: CNPlayer, didMoveToPosition position: CGPoint)
    
    func player(player: CNPlayer, willRotateFromAngle angle: CGFloat)
    func player(player: CNPlayer, didRotateToAngle angle: CGFloat)
    
    func player(player: CNPlayer, didTailChangeTo change: Bool)
    
}

class CNVariable {
    var name: String
    var value: CNValue
    
    init(name: String, value: CNValue) {
        self.name = name
        self.value = value
    }
}

class CNProgram: CNBlock {
    
    var player = CNPlayer()
    
    var playerDelegate: CNPlayerDelegate?
    
    func prepare() throws {
        try prepare(self)
    }
    
    func execute() throws -> CNValue {
        return try execute(self)
    }

}

class CNPlayer {
    var position: CGPoint = CGPointZero
    var angle: CGFloat = 0.0
    var tailDown: Bool = true {
        didSet {
            program.playerDelegate?.player(self, didTailChangeTo: tailDown)
        }
    }
    
    private func moveTo(newPosition: CGPoint) {
        program.playerDelegate?.player(self, willMoveFromPosition: position)
        position = newPosition
        program.playerDelegate?.player(self, didMoveToPosition: position)
    }
    
    func moveForward(distance: CNExpression, inBlock: CNBlock) throws {
        switch try distance.execute(inBlock) {
        case let .double(value):
            let newPosition = CGPointMake(
                position.x + cos(angle) * CGFloat(value),
                position.y + sin(angle) * CGFloat(value)
            )
            moveTo(newPosition)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func moveBackward(distance: CNExpression, inBlock: CNBlock) throws {
        switch try distance.execute(inBlock) {
        case let .double(value):
            let newPosition = CGPointMake(
                position.x + cos(angle) * CGFloat(-value),
                position.y + sin(angle) * CGFloat(-value)
            )
            moveTo(newPosition)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func rotate(angleDelta: CNExpression, inBlock: CNBlock) throws {
        switch try angleDelta.execute(inBlock) {
        case let .double(value):
            program.playerDelegate?.player(self, willRotateFromAngle: angle)
            angle = angle + CGFloat(value * M_PI / 180.0)
            program.playerDelegate?.player(self, didRotateToAngle: angle)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
}
