//
//  CNBlockVisual.swift
//  CNLogo
//
//  Created by Igor Smirnov on 27/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import CNLogoCore
import UIKit

extension CNLCBlock {
    
    func createBlockBubbles(inBlock: CNLCBlock, height: CGFloat, prefix: String = "", bold: Bool = false) -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubbleView(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: bold)
            res.append(bubble)
        }
        
        return res
    }
    
    @objc func createBubbles(inBlock: CNLCBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res = createBlockBubbles(inBlock, height: height)
        if prefix == "" {
            for param in executableParameters {
                res += param.createBubbles(inBlock, height: height)
            }
        }
        return res
    }
    
    
}
