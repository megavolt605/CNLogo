//
//  CNStatement+CNBubbleView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNStatement {
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubbleView(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }
        
        if prefix == "" {
            for param in executableParameters {
                res += param.createBubbles(inBlock, height: height)
            }
        }
        return res
    }
    
    
}
