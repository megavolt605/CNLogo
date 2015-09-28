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

public var program: CNProgram!

public enum CNError: ErrorType {
    case Unknown
    
    public var description: String {
        switch self {
        case .Unknown: return "Unknown error"
        }
    }
}

public class CNProgram: CNBlock {

    override public var name: String {
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
    
    override public init(parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        super.init(parameters: parameters, statements: statements, functions: functions)
        variables.append(CNVariable(name: "PI", value: CNValue.double(value: M_PI)))
        variables.append(CNVariable(name: "2*PI", value: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(name: "PI/2", value: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(name: "EXP", value:  CNValue.double(value: M_E)))
    }
    
}

