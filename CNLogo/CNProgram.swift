//
//  CNProgram.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

var program: CNProgram!

protocol CNPlayerDelegate {
    
    func player(player: CNPlayer, willMoveFromPosition fromPosition: CGPoint, toPosition: CGPoint )
    func player(player: CNPlayer, didMoveFromPosition position: CGPoint, toPosition: CGPoint)
    
    func player(player: CNPlayer, willRotateFromAngle angle: CGFloat, toAngle: CGFloat)
    func player(player: CNPlayer, didRotateFromAngle angle: CGFloat, toAngle: CGFloat)
    
    func player(player: CNPlayer, didTailChangeTo change: Bool)

    func player(player: CNPlayer, willSetColor color: UIColor)
    func player(player: CNPlayer, didSetColor color: UIColor)

    func player(player: CNPlayer, willSetWidth width: CGFloat)
    func player(player: CNPlayer, didSetWidth width: CGFloat)

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
    var color: UIColor = UIColor.blackColor()
    var width: CGFloat = 2.0
    var tailDown: Bool = true {
        didSet {
            program.playerDelegate?.player(self, didTailChangeTo: tailDown)
        }
    }
    
    private func moveTo(newPosition: CGPoint) {
        program.playerDelegate?.player(self, willMoveFromPosition: position, toPosition: newPosition)
        let oldPosition = position
        position = newPosition
        program.playerDelegate?.player(self, didMoveFromPosition: oldPosition, toPosition: position)
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
            let oldAngle = angle
            let newAngle = angle + CGFloat(value * M_PI / 180.0)
            program.playerDelegate?.player(self, willRotateFromAngle: angle, toAngle: newAngle)
            angle = newAngle
            program.playerDelegate?.player(self, didRotateFromAngle: oldAngle, toAngle: newAngle)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }

    func setColor(color: CNExpression, inBlock: CNBlock) throws {
        switch try color.execute(inBlock) {
        case let .color(value):
            program.playerDelegate?.player(self, willSetColor: value)
            self.color = value
            program.playerDelegate?.player(self, didSetColor: value)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func setWidth(color: CNExpression, inBlock: CNBlock) throws {
        switch try color.execute(inBlock) {
        case let .double(value):
            program.playerDelegate?.player(self, willSetWidth: CGFloat(value))
            self.width = CGFloat(value)
            program.playerDelegate?.player(self, didSetWidth: CGFloat(value))
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
}
