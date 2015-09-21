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

enum CNError: ErrorType {
    case Unknown
    
    var description: String {
        switch self {
        case .Unknown: return "Unknown error"
        }
    }
}

class CNProgram: CNBlock {

    override var description: String {
        return "PROGRAM"
    }
    
    var player = CNPlayer()
    var executionHistory = CNExecutionHistory()
    
    func clear() {
        executionHistory.clear()
        player.clear()
    }
    
    override func execute() throws -> CNValue {
        player.clear()
        return try super.execute()
    }
    
    override init(parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        super.init(parameters: parameters, statements: statements, functions: functions)
        variables.append(CNVariable(name: "PI", value: CNValue.double(value: M_PI)))
        variables.append(CNVariable(name: "2*PI", value: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(name: "PI/2", value: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(name: "EXP", value:  CNValue.double(value: M_E)))
    }
    
}

