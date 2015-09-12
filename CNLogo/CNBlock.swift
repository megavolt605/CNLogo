//
//  CNBlock.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNBlock {
    
    var parameters: [CNExpression]
    var statements: [CNStatement] {
        didSet {
            statements.forEach {
                $0.parentBlock = self
            }
        }
    }
    var variables: [CNVariable] = []
    var functions: [CNFunction] = []
    weak var parentBlock: CNBlock?

    func prepare(inBlock: CNBlock) throws -> Void {
        try statements.forEach {
            $0.parentBlock = self
            try $0.prepare(inBlock)
        }
    }
    
    func execute(inBlock: CNBlock) throws -> CNValue {
        try statements.forEach {
            try $0.execute(inBlock)
        }
        return CNValue.unknown
    }
    
    func variableByName(name: String) -> CNVariable? {
        for v in variables {
            if v.name == name {
                return v
            }
        }
        return parentBlock?.variableByName(name)
    }
    
    func functionByName(name: String) -> CNFunction? {
        for f in functions {
            if f.name == name {
                return f
            }
        }
        return parentBlock?.functionByName(name)
    }
    
    init(parameters: [CNExpression] = [], statements: [CNStatement] = [], functions: [CNFunction] = []) {
        self.parameters = parameters
        self.statements = statements
        self.functions = functions
    }
    
}
