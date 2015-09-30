//
//  CNStatement.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatement: CNBlock {
    
    override public var identifier: String {
        return "Anonymous STATEMENT \(self)"
    }
    
    func throwError(code: Int = 0) throws {
        throw NSError(domain: "\(self)", code: 0, userInfo: nil)
    }

}
