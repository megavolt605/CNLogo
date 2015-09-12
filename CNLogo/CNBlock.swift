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
            parameters.forEach {
                $0.parentBlock = self
            }
            statements.forEach {
                $0.parentBlock = self
            }
        }
    }
    var variables: [CNVariable] = []
    var functions: [CNFunction] = []
    private var prepared = false
    weak var parentBlock: CNBlock?

    func prepare() throws -> Void {
        try parameters.forEach {
            $0.parentBlock = self
            try $0.prepare()
        }
        try statements.forEach {
            $0.parentBlock = self
            try $0.prepare()
        }
        prepared = true
    }
    
    func execute() throws -> CNValue {
        if !prepared {
            try prepare()
        }
        
        try statements.forEach {
            try $0.execute()
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
