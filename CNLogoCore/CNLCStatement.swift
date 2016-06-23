//
//  CNLCStatement.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNLCStatement: CNLCBlock {
    
    override public var identifier: String {
        return "Anonymous STATEMENT \(self)"
    }
    
    override public func store() -> [String: AnyObject] {
        return ["statement-id": identifier, "statement-info": super.store()]
    }
    
    override public required init(data: [String: AnyObject]) {
        super.init()
    }
    
    override public required init(statements: [CNLCStatement]) {
        super.init(statements: statements)
    }

    override public required init(executableParameters: [CNLCVariable]) {
        super.init(executableParameters: executableParameters)
    }
    
    override public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        super.init(executableParameters: executableParameters, statements: statements)
    }
    
}
