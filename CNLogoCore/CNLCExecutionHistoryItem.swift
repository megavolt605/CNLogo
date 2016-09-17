//
//  CNLCExecutionHistoryItem.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

public enum CNLCExecutionHistoryItemType {
    case clear
    case move(fromPoint: CGPoint, toPoint: CGPoint, forward: Bool)
    case rotate(fromAngle: CGFloat, toAngle: CGFloat)
    case tailState(fromState: Bool, toState: Bool)
    case color(fromColor: CGColor, toColor: CGColor)
    case width(fromWidth: CGFloat, toWidth: CGFloat)
    case scale(fromScale: CGFloat, toScale: CGFloat)
    case step, stepIn, stepOut
    case print(value: String)
}

// TODO: add call stack snapshot with parameters and variables
public struct CNLCExecutionHistoryItem {
    
    public var type: CNLCExecutionHistoryItemType
    public var playerState: CNLCPlayerState
    public weak var block: CNLCBlock?
    
    public var description: String {
        switch type {
        case .clear: return "Clear"
        case let .move(_, toPoint, _): return String(format: "Forward to %.2f - %.2f", toPoint.x, toPoint.y)
        case let .rotate(_, toAngle): return String(format: "Rotate to %.2f", toAngle)
        case let .tailState(_, toState): return "Tail down \(toState)"
        case .color: return "Color"
        case let .width(_, toWidth): return String(format: "Width %.2f", toWidth)
        case let .scale(_, toScale): return String(format: "Scale %.2f", toScale)
        case .step: return "Step"
        case .stepIn: return "Step In"
        case .stepOut: return "Step Out"
        case let .print(value): return "Print '\(value)'"
        }
    }
    
}
