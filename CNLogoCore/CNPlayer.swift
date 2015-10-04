//
//  CNPlayer.swift
//  CNLogo
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import UIKit

public struct CNPlayerState {
    public var position: CGPoint = CGPointZero
    public var angle: CGFloat = 0.0
    public var color: CGColor = UIColor.blackColor().CGColor
    public var width: CGFloat = 2.0
    public var tailDown: Bool = true
    public var scale: CGFloat = 1.0
    
    public func snapshot() -> CNPlayerState {
        var res = self
        res.color = CGColorCreateCopy(color)!
        return res
    }
    
}

public class CNPlayer {
    
    public var state = CNPlayerState()
    public var startState = CNPlayerState()
    
    public func clear(fromBlock: CNBlock?) {
        state = startState
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Clear, block: fromBlock)
    }
    
    public func tailDown(isDown: Bool, fromBlock: CNBlock?) {
        let oldTailDown = state.tailDown
        state.tailDown = isDown
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.TailState(fromState: oldTailDown, toState: isDown), block: fromBlock)
    }
    
    private func moveTo(newPosition: CGPoint, forward: Bool, fromBlock: CNBlock?) {
        let oldPosition = state.position
        state.position = newPosition
        CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Move(fromPoint: oldPosition, toPoint: newPosition, forward: forward), block: fromBlock)
    }
    
    public func moveForward(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x + cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y + sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: true, fromBlock: fromBlock)
        case let .int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x + cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y + sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: true, fromBlock: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
    public func moveBackward(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x - cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y - sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: false, fromBlock: fromBlock)
        case let .int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x - cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y - sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: false, fromBlock: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
    public func rotate(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .double(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(angleDelta * M_PI / 180.0)
            state.angle = newAngle
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Rotate(fromAngle: oldAngle, toAngle: newAngle), block: fromBlock)
        case let .int(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(Double(angleDelta) * M_PI / 180.0)
            state.angle = newAngle
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Rotate(fromAngle: oldAngle, toAngle: newAngle), block: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
    public func setColor(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .color(newColor):
            let oldColor = state.color
            state.color = newColor.CGColor
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Color(fromColor: oldColor, toColor: state.color), block: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
    public func setWidth(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .double(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Width(fromWidth: oldWidth, toWidth: state.width), block: fromBlock)
        case let .int(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Width(fromWidth: oldWidth, toWidth: state.width), block: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
    public func setScale(value: CNExpression, fromBlock: CNBlock?) throws {
        switch try value.execute() {
        case let .double(newScale):
            let oldScale = state.scale
            state.scale = CGFloat(newScale)
            CNEnviroment.defaultEnviroment.currentProgram.executionHistory.append(CNExecutionHistoryItemType.Scale(fromScale: oldScale, toScale: state.scale), block: fromBlock)
        default: throw CNError.NumericValueExpected
        }
    }
    
}
