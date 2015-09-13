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

protocol CNProgramDelegate {
    
    func programWillClear(program: CNProgram)
    
}

class CNProgram: CNBlock {
    
    var player = CNPlayer()
    
    var playerDelegate: CNPlayerDelegate?
    var programDelegate: CNProgramDelegate?
    
    func clear() {
        programDelegate?.programWillClear(self)
    }
    
    override init(parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        super.init(parameters: parameters, statements: statements, functions: functions)
        variables.append(CNVariable(name: "PI", value: CNValue.double(value: M_PI)))
        variables.append(CNVariable(name: "2*PI", value: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(name: "PI/2", value: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(name: "EXP", value:  CNValue.double(value: M_E)))
    }
    
}
