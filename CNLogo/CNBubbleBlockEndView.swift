//
//  CNBubbleBlockEndView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

class CNBubbleBlockEndView: CNBubbleView {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        let str = NSAttributedString(string: text, attributes: attrs)
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 8.0, size.height)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        
        let rectangleRect = CGRectMake(0.0, 5.0, size.width, size.height - 10.0)
        let rectanglePath = UIBezierPath(
            roundedRect: rectangleRect,
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSizeMake(size.height / 4.0, size.height / 4.0)
        )
        rectanglePath.closePath()
        rectanglePath.moveToPoint(CGPointZero)
        rectanglePath.addLineToPoint(CGPointMake(4.0, 0.0))
        rectanglePath.addLineToPoint(CGPointMake(4.0, size.height / 2.0))
        rectanglePath.addLineToPoint(CGPointMake(0.0, size.height / 2.0))
        rectanglePath.closePath()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
}
