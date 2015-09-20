//
//  CNPlayer.swift
//  CNLogo
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import UIKit

struct CNPlayerState {
    var position: CGPoint = CGPointZero
    var angle: CGFloat = 0.0
    var color: CGColor = UIColor.blackColor().CGColor
    var width: CGFloat = 2.0
    var tailDown: Bool = true
    
    func snapshot() -> CNPlayerState {
        var res = self
        res.color = CGColorCreateCopy(color)!
        return res
    }
    
}

class CNPlayer {
    
    var state = CNPlayerState()
    var startState = CNPlayerState()
    
    func clear() {
        state = startState
        program.executionHistory.append(CNExecutionHistoryItemType.Clear)
    }
    
    func tailDown(isDown: Bool) {
        let oldTailDown = state.tailDown
        state.tailDown = isDown
        program.executionHistory.append(CNExecutionHistoryItemType.TailState(fromState: oldTailDown, toState: isDown))
    }
    
    private func moveTo(newPosition: CGPoint, forward: Bool) {
        let oldPosition = state.position
        state.position = newPosition
        program.executionHistory.append(CNExecutionHistoryItemType.Move(fromPoint: oldPosition, toPoint: newPosition, forward: forward))
    }
    
    func moveForward(value: CNExpression) throws {
        switch try value.execute() {
        case let .double(distance):
            let newPosition = CGPointMake(
                state.position.x + cos(state.angle - CGFloat(M_PI_2)) * CGFloat(distance),
                state.position.y + sin(state.angle - CGFloat(M_PI_2)) * CGFloat(distance)
            )
            moveTo(newPosition, forward: true)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func moveBackward(value: CNExpression) throws {
        switch try value.execute() {
        case let .double(distance):
            let newPosition = CGPointMake(
                state.position.x - cos(state.angle - CGFloat(M_PI_2)) * CGFloat(distance),
                state.position.y - sin(state.angle - CGFloat(M_PI_2)) * CGFloat(distance)
            )
            moveTo(newPosition, forward: false)
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func rotate(value: CNExpression) throws {
        switch try value.execute() {
        case let .double(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(angleDelta * M_PI / 180.0)
            state.angle = newAngle
            program.executionHistory.append(CNExecutionHistoryItemType.Rotate(fromAngle: oldAngle, toAngle: newAngle))
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func setColor(value: CNExpression) throws {
        switch try value.execute() {
        case let .color(newColor):
            let oldColor = state.color
            state.color = newColor.CGColor
            program.executionHistory.append(CNExecutionHistoryItemType.Color(fromColor: oldColor, toColor: state.color))
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
    func setWidth(value: CNExpression) throws {
        switch try value.execute() {
        case let .double(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth)
            program.executionHistory.append(CNExecutionHistoryItemType.Width(fromWidth: oldWidth, toWidth: state.width))
        default: throw NSError(domain: "Float expected", code: 0, userInfo: nil)
        }
    }
    
}
