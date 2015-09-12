//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNPrint: CNStatement {
    
    override func execute(inBlock: CNBlock) throws -> CNValue {
        try parameters.forEach {
            print(try $0.execute(inBlock).description)
        }
        return .unknown
    }
    
}

