//
//  CNFieldView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

struct CNFieldElement {
    
    var fromPoint: CGPoint
    var toPoint: CGPoint
    var visible: Bool
    
    let lineWidth: CGFloat
    let lineColor: UIColor
    
    func drawInContext(context: CGContextRef) {
        if visible {
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
            CGContextSetLineWidth(context, lineWidth)
            CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
            CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        } else {
            CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        }
    }
    
}

class CNFieldView: UIView {
    
    var elements: [CNFieldElement] = []
    
    override func drawRect(rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext() {
            elements.forEach {
                $0.drawInContext(ctx)
            }
            CGContextStrokePath(ctx)
        }
    }
    
    func clear() {
        elements = []
        setNeedsDisplay()
    }
    
}
