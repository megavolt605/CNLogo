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
    
    public func clear(fromBlock: CNBlock?) -> CNValue {
        state = startState
        CNEnviroment.defaultEnviroment.appendExecutionHistory(
            CNExecutionHistoryItemType.Clear,
            fromBlock: fromBlock
        )
        return .Unknown
    }
    
    public func tailDown(isDown: Bool, fromBlock: CNBlock?) -> CNValue {
        let oldTailDown = state.tailDown
        state.tailDown = isDown
        CNEnviroment.defaultEnviroment.appendExecutionHistory(
            CNExecutionHistoryItemType.TailState(
                fromState: oldTailDown,
                toState: isDown
            ),
            fromBlock: fromBlock
        )
        return .Unknown
    }
    
    private func moveTo(newPosition: CGPoint, forward: Bool, fromBlock: CNBlock?) -> CNValue {
        let oldPosition = state.position
        state.position = newPosition
        CNEnviroment.defaultEnviroment.appendExecutionHistory(
            CNExecutionHistoryItemType.Move(
                fromPoint: oldPosition,
                toPoint: newPosition,
                forward: forward
            ),
            fromBlock: fromBlock
        )
        return .Unknown
    }
    
    public func moveForward(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x + cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y + sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: true, fromBlock: fromBlock)
        case let .Int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x + cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y + sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: true, fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
    public func moveBackward(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x - cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y - sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: false, fromBlock: fromBlock)
        case let .Int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPointMake(
                state.position.x - cos(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance),
                state.position.y - sin(state.angle - CGFloat(M_PI_2)) * CGFloat(scaledDistance)
            )
            moveTo(newPosition, forward: false, fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
    public func rotate(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Double(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(angleDelta * M_PI / 180.0)
            state.angle = newAngle
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Rotate(fromAngle: oldAngle, toAngle: newAngle), fromBlock: fromBlock)
        case let .Int(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(Double(angleDelta) * M_PI / 180.0)
            state.angle = newAngle
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Rotate(fromAngle: oldAngle, toAngle: newAngle), fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
    public func setColor(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Color(newColor):
            let oldColor = state.color
            state.color = newColor.CGColor
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Color(fromColor: oldColor, toColor: state.color), fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
    public func setWidth(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Double(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Width(fromWidth: oldWidth, toWidth: state.width), fromBlock: fromBlock)
        case let .Int(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Width(fromWidth: oldWidth, toWidth: state.width), fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
    public func setScale(value: CNExpression, fromBlock: CNBlock?) -> CNValue {
        let result = value.execute()
        switch result {
        case let .Double(newScale):
            let oldScale = state.scale
            state.scale = CGFloat(newScale)
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Scale(fromScale: oldScale, toScale: state.scale), fromBlock: fromBlock)
        case .Error: return result
        default: return .Error(block: fromBlock, error: .NumericValueExpected)
        }
        return .Unknown
    }
    
}
