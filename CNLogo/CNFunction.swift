//
//  CNFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNFunction {
    
    var parameters: [CNExpression]

    func prepare(inBlock: CNBlock) throws {
        
    }
    
    func execute(inBlock: CNBlock) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(parameters: [CNExpression]) {
        self.parameters = parameters
    }
    
    init() {
        self.parameters = []
    }
    
}

