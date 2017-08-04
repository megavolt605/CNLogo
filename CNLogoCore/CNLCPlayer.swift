//
//  CNLCPlayer.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import UIKit

public struct CNLCPlayerState {
    public var position: CGPoint = CGPoint.zero
    public var angle: CGFloat = 0.0
    public var color: CGColor = UIColor.black.cgColor
    public var width: CGFloat = 2.0
    public var tailDown: Bool = true
    public var scale: CGFloat = 1.0
    
    public func snapshot() -> CNLCPlayerState {
        var res = self
        res.color = color.copy()!
        return res
    }
    
}

open class CNLCPlayer {
    
    open var state = CNLCPlayerState()
    open var startState = CNLCPlayerState()
    
    open func clear(_ fromBlock: CNLCBlock?) -> CNLCValue {
        state = startState
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(
            CNLCExecutionHistoryItemType.clear,
            fromBlock: fromBlock
        )
        return .unknown
    }
    
    open func tailDown(_ isDown: Bool, fromBlock: CNLCBlock?) -> CNLCValue {
        let oldTailDown = state.tailDown
        state.tailDown = isDown
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(
            CNLCExecutionHistoryItemType.tailState(
                fromState: oldTailDown,
                toState: isDown
            ),
            fromBlock: fromBlock
        )
        return .unknown
    }
    
    fileprivate func moveTo(_ newPosition: CGPoint, forward: Bool, fromBlock: CNLCBlock?) -> CNLCValue {
        let oldPosition = state.position
        state.position = newPosition
        CNLCEnviroment.defaultEnviroment.appendExecutionHistory(
            CNLCExecutionHistoryItemType.move(
                fromPoint: oldPosition,
                toPoint: newPosition,
                forward: forward
            ),
            fromBlock: fromBlock
        )
        return .unknown
    }
    
    open func moveForward(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPoint(
                x: state.position.x + cos(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance),
                y: state.position.y + sin(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance)
            )
            return moveTo(newPosition, forward: true, fromBlock: fromBlock)
        case let .int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPoint(
                x: state.position.x + cos(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance),
                y: state.position.y + sin(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance)
            )
            return moveTo(newPosition, forward: true, fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
    }
    
    open func moveBackward(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .double(distance):
            let scaledDistance = distance * Double(state.scale)
            let newPosition = CGPoint(
                x: state.position.x - cos(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance),
                y: state.position.y - sin(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance)
            )
            return moveTo(newPosition, forward: false, fromBlock: fromBlock)
        case let .int(distance):
            let scaledDistance = Double(distance) * Double(state.scale)
            let newPosition = CGPoint(
                x: state.position.x - cos(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance),
                y: state.position.y - sin(state.angle - CGFloat(Double.pi / 2.0)) * CGFloat(scaledDistance)
            )
            return moveTo(newPosition, forward: false, fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
    }
    
    open func rotate(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .double(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(angleDelta * Double.pi / 180.0)
            state.angle = newAngle
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.rotate(fromAngle: oldAngle, toAngle: newAngle), fromBlock: fromBlock)
        case let .int(angleDelta):
            let oldAngle = state.angle
            let newAngle = state.angle + CGFloat(Double(angleDelta) * Double.pi / 180.0)
            state.angle = newAngle
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.rotate(fromAngle: oldAngle, toAngle: newAngle), fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
        return .unknown
    }
    
    open func setColor(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .color(newColor):
            let oldColor = state.color
            state.color = newColor.cgColor
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.color(fromColor: oldColor, toColor: state.color), fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
        return .unknown
    }
    
    open func setWidth(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .double(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.width(fromWidth: oldWidth, toWidth: state.width), fromBlock: fromBlock)
        case let .int(newWidth):
            let oldWidth = state.width
            state.width = CGFloat(newWidth) * state.scale
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.width(fromWidth: oldWidth, toWidth: state.width), fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
        return .unknown
    }
    
    open func setScale(_ value: CNLCExpression, fromBlock: CNLCBlock?) -> CNLCValue {
        let result = value.execute()
        switch result {
        case let .double(newScale):
            let oldScale = state.scale
            state.scale = CGFloat(newScale)
            CNLCEnviroment.defaultEnviroment.appendExecutionHistory(CNLCExecutionHistoryItemType.scale(fromScale: oldScale, toScale: state.scale), fromBlock: fromBlock)
        case .error: return result
        default: return .error(block: fromBlock, error: .numericValueExpected)
        }
        return .unknown
    }
    
}
