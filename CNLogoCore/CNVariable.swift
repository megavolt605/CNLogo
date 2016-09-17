//
//  CNLCVariable.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

/// Variable of any type with value
open class CNLCVariable {
    open var variableName: String
    open var variableValue: CNLCExpression
    open var parentBlock: CNLCBlock?
    
    public init(variableName: String, variableValue: CNLCExpression) {
        self.variableName = variableName
        self.variableValue = variableValue
    }
    
    public init(variableName: String, variableValue: CNLCValue) {
        self.variableName = variableName
        self.variableValue = CNLCExpression(source: [CNLCExpressionParseElement.Value(value: variableValue)])
    }
    
}
