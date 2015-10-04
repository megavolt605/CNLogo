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
    
    override public func store() -> [String: AnyObject] {
        return ["statement-id": identifier, "statement-info": super.store()]
    }
    
}
