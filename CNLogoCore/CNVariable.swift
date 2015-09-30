//
//  CNVariable.swift
//  CNLogo
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNVariable {
    var variableName: String
    var variableValue: CNValue
    
    init(variableName: String, variableValue: CNValue) {
        self.variableName = variableName
        self.variableValue = variableValue
    }
}
