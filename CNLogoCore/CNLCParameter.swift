//
//  CNLCParameter.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

// TODO: Anonymous parameter
open class CNLCParameter: CNLCVariable {
    
    public init(value: CNLCExpression) {
        super.init(variableName: "", variableValue: value)
    }
    
    public init(value: CNLCValue) {
        super.init(variableName: "", variableValue: value)
    }
    
}
