//
//  CNOptions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 04/10/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

struct CNOptions {
    
    var duration: CFTimeInterval = 0.01
    
    var shouldAnimate: Bool {
        return duration >= 0.01
    }
    
}