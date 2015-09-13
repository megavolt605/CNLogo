//
//  CNVariable.swift
//  CNLogo
//
//  Created by Igor Smirnov on 13/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNVariable {
    var name: String
    var value: CNValue
    
    init(name: String, value: CNValue) {
        self.name = name
        self.value = value
    }
}
