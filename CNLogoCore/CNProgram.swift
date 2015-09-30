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

public enum CNError: ErrorType {
    case Unknown
    
    public var description: String {
        switch self {
        case .Unknown: return "Unknown error"
        }
    }
}

public class CNProgram: CNBlock {

    override public var identifier: String {
        return "PROGRAM"
    }
    
    public var player = CNPlayer()

    public var executionHistory = CNExecutionHistory()
    
    public func clear() {
        player.clear(nil)
        executionHistory.clear()
    }
    
    override public func execute() throws -> CNValue {
        clear()
        return try super.execute()
    }
    
    override public func commonInit() {
        variables.append(CNVariable(variableName: "PI", variableValue: CNValue.double(value: M_PI)))
        variables.append(CNVariable(variableName: "2*PI", variableValue: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(variableName: "PI/2", variableValue: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(variableName: "EXP", variableValue:  CNValue.double(value: M_E)))
    }
    
}

