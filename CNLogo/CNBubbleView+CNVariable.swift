//
//  CNBubbleView+CNVariable.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNVariable {
    
    func createBubbles(inBlock: CNBlock, height: CGFloat) -> [CNBubbleView] {
        return self.variableValue.createBubbles(inBlock, height: height)
    }
    
}
