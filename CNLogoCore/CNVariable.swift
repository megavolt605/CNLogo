//
//  CNVariable.swift
//  CNLogo
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

/// Variable of any type with value
@objc public class CNVariable: NSObject {
    public var variableName: String
    public var variableValue: CNExpression
    public var parentBlock: CNBlock?
    
    public init(variableName: String, variableValue: CNExpression) {
        self.variableName = variableName
        self.variableValue = variableValue
    }
    
    public init(variableName: String, variableValue: CNValue) {
        self.variableName = variableName
        self.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: variableValue)])
    }
    
}

// TODO: Anonymous parameter
public class CNParameter: CNVariable {

    public init(value: CNExpression) {
        super.init(variableName: "", variableValue: value)
    }
    
    public init(value: CNValue) {
        super.init(variableName: "", variableValue: value)
    }
    
}