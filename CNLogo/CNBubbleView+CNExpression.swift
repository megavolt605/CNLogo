//
//  CNBubbleView+CNExpression.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNLCExpression {
    
    @objc override func createBubbles(inBlock: CNLCBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        if prefix != "" {
            let bubble = CNBubbleView(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        for item in source {
            res += item.createBubbles(inBlock, height: height)
        }
        return res
    }
    
}
