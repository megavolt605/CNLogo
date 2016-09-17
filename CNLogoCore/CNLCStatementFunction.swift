//
//  CNLCStatementFunction.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

open class CNLCStatementFunction: CNLCStatement {
    
    override open var identifier: String {
        return "FUNC"
    }
    
    open var funcName: String
    
    override open var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    open override func prepare() -> CNLCBlockPrepareResult {
        let result = super.prepare()
        parentBlock?.functions.append(self)
        return result
    }
    
    open override func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        // dummy
        return .unknown
    }
    
    func execute() -> CNLCValue {
        return .unknown
    }
    
    public init(funcName: String, formalParameters: [CNLCVariable] = [], statements: [CNLCStatement]) {
        self.funcName = funcName
        super.init(statements: statements)
        self.formalParameters = formalParameters
    }

    required public init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        fatalError("init(executableParameters:statements:) has not been implemented")
    }
    
    public required init(executableParameters: [CNLCVariable]) {
        fatalError("init(executableParameters:) has not been implemented")
    }
    
    public required init(statements: [CNLCStatement]) {
        fatalError("init(statements:) has not been implemented")
    }
    
    public required init(data: [String : Any]) {
        fatalError("init(data:) has not been implemented")
    }
}
