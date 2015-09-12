//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNStatementPrint: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try parameters.forEach {
            print(try $0.execute(inBlock).description)
        }
        return .unknown
    }
    
}

class CNStatementVar: CNStatement {
    
    var name: String
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count > 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        let variable = inBlock.variableByName(name)
        if let value = try parameters.first?.execute(inBlock) {
            variable?.value = value
        } else {
            variable?.value = CNValue.unknown
        }
        return .unknown
    }
    
    init(name: String, parameters: [CNExpression]) {
        self.name = name
        super.init(parameters: parameters)
    }

    init(name: String) {
        self.name = name
        super.init(parameters: [])
    }
    
}

/*
class CNStatementLet: CNStatement {
    
}
*/