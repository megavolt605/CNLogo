//
//  CNBlock.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNBlock: CNFunction {
    
    var statements: [CNStatement]
    var variables: [CNVariable] = []

    override func prepare(inBlock: CNBlock) throws -> Void {
        try super.prepare(inBlock)
        try statements.forEach {
            try $0.prepare(inBlock)
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
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
        return nil
    }

    init(parameters: [CNExpression], statements: [CNStatement]) {
        self.statements = statements
        super.init(parameters: parameters)
    }
    
    override init(parameters: [CNExpression]) {
        self.statements = []
        super.init(parameters: parameters)
    }
    
    override convenience init() {
        self.init(parameters: [])
    }
    
}
