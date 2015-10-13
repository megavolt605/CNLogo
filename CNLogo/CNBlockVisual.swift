//
//  CNBlockVisual.swift
//  CNLogo
//
//  Created by Igor Smirnov on 27/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import CNLogoCore
import UIKit

extension CNBlock {
    
    @objc func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
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

extension CNStatement {
    
    @objc override func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
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
            let bubble = CNBubble(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
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

extension CNExecutableParameter {
    
    func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        if prefix != "" {
            let bubble = CNBubble(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        return res
    }
    
    
}


extension CNStatementVar {
    
    @objc override func createBubbles(height: CGFloat, prefix: String = "") -> [CNBubble]? {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }

        var bubble = CNBubble(text: variableName, color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false)
        res.append(bubble)
        
        bubble = CNBubble(text: "=", color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false)
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
        switch self {
        case let .Value(value):
            switch value {
            case let .color(color):
                return [CNBubble(text: "  ", color: color, height: height, bold: false)]
            default:
                return [CNBubble(
                    text: description,
                    color: UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), height: height, bold: false
                    )]
            }
        case let .Variable(name):
            return [CNBubble(
                text: name,
                color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false
                )]
        default: break
        }
        return [CNBubble(
            text: description,
            color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false
        )]
    }
    
}