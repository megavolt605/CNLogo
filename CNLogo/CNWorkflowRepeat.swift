//
//  CNWorkflowRepeat.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNRepeat: CNStatement {
    
    override func prepare(inBlock: CNBlock) throws {
        if parameters.count != 1 {
            try throwError()
        }
    }
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        switch try parameters.first!.execute(inBlock) {
        case let .int(value):
            for _ in 0..<value {
                try statements.forEach {
                    try $0.execute(inBlock)
                }
            }
        default: throw NSError(domain: "Int expected", code: 0, userInfo: nil)
        }
        return .unknown
    }
    
}