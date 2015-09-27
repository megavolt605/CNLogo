//
//  CNBlockVisual.swift
//  CNLogo
//
//  Created by Igor Smirnov on 27/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

extension CNBlock {
    
    @objc func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        let bubbleName = prefix + name
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height)
            res.append(bubble)
        }
        
        if prefix == "" {
            for param in parameters {
                if let bubbles = param.createBubbles(height) {
                    res += bubbles
                }
            }
        }
        return res
    }
    
    
}

extension CNExpression {
    
    @objc override func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        if prefix != "" {
            let bubble = CNBubble(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height)
            res.append(bubble)
        }
        for item in source {
            if let bubbles = item.createBubbles(height) {
                res += bubbles
            }
        }
        return res
    }
    
    
}

extension CNStatementVar {
    
    @objc override func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        let bubbleName = prefix + name
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height)
            res.append(bubble)
        }

        var bubble = CNBubble(text: varName, color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height)
        res.append(bubble)
        
        bubble = CNBubble(text: "=", color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height)
        res.append(bubble)
        
        for param in parameters {
            if let bubbles = param.createBubbles(height) {
                res += bubbles
            }
        }
        return res
    }
    
    
}

extension CNExpressionParseElement {

    func createBubbles(height: CGFloat) -> [CNBubble]? {
        return [CNBubble(
            text: description,
            color: UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), height: height
        )]
    }
    
}