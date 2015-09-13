//
//  CNProgram.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

var program: CNProgram!

protocol CNProgramDelegate {
    
    func programWillClear(program: CNProgram)
    
}

class CNProgram: CNBlock {
    
    var player = CNPlayer()
    
    var playerDelegate: CNPlayerDelegate?
    var programDelegate: CNProgramDelegate?
    
    func clear() {
        programDelegate?.programWillClear(self)
    }
    
}
