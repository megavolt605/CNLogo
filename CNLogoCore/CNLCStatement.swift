//
//  CNLCStatement.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

open class CNLCStatement: CNLCBlock {
    
    override open var identifier: String {
        return "Anonymous STATEMENT \(self)"
    }
    
    override open func store() -> [String: Any] {
        return ["statement-id": identifier as AnyObject, "statement-info": super.store() as AnyObject]
    }
    
    override public init() {
        super.init()
    }
    
    override public required init(data: [String: Any]) {
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
