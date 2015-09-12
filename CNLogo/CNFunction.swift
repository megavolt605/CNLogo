//
//  CNFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNFunction: CNBlock {
    
    var name: String
    
    func prepareWithParameters(parameters: [CNExpression]) throws {
        
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(name: String, parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction]) {
        self.name = name
        super.init(parameters: parameters, statements: statements, functions: functions)
    }
}

