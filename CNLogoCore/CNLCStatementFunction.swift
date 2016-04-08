//
//  CNLCStatementFunction.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNLCStatementFunction: CNLCStatement {
    
    override public var identifier: String {
        return "FUNC"
    }
    
    public var funcName: String
    
    override public var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    public override func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        parentBlock?.functions.append(self)
        return result
    }
    
    public override func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        // dummy
        return .Unknown
    }
    
    func execute() -> CNLCValue {
        return .Unknown
    }
    
    public init(funcName: String, formalParameters: [CNLCVariable] = [], statements: [CNLCStatement]) {
        self.funcName = funcName
        super.init(statements: statements)
        self.formalParameters = formalParameters
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
}
