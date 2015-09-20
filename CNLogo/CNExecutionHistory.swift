//
//  CNExecutionHistory.swift
//  CNLogo
//
//  Created by Igor Smirnov on 20/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics

class CNExecutionHistory {
    
    var history: [CNExecutionHistoryItem] = []
    
    func append(itemType: CNExecutionHistoryItemType) {
        let playerState = program.player.state.snapshot()
        history.append(CNExecutionHistoryItem(type: itemType, playerState: playerState))
    }
    
    func clear() {
        history = []
    }
    
}

// TODO: add call stack snapshot with parameters and variables
struct CNExecutionHistoryItem {

    var type: CNExecutionHistoryItemType
    var playerState: CNPlayerState

    var description: String {
        switch type {
        case .Clear: return "Clear"
        case let .Move(_, toPoint, _): return String(format: "Forward to %.2f - %.2f", toPoint.x, toPoint.y)
        case let .Rotate(_, toAngle): return String(format: "Rotate to %.2f", toAngle)
        case let .TailState(_, toState): return "Tail down \(toState)"
        case .Color: return "Color"
        case let .Width(_, toWidth): return String(format: "Width %.2f", toWidth)
        }
    }
    
}

enum CNExecutionHistoryItemType {
    case Clear
    case Move(fromPoint: CGPoint, toPoint: CGPoint, forward: Bool)
    case Rotate(fromAngle: CGFloat, toAngle: CGFloat)
    case TailState(fromState: Bool, toState: Bool)
    case Color(fromColor: CGColor, toColor: CGColor)
    case Width(fromWidth: CGFloat, toWidth: CGFloat)
}