//
//  CNBubbleBlockShiftView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

class CNBubbleBlockShiftView: CNBubbleView {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 12.0, size.height)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        let size = CGSizeMake(self.size.width - 8.0, self.size.height)
        
        let rectangleRect = CGRect(origin: CGPointZero, size: size)
        let rectanglePath = UIBezierPath(rect: rectangleRect)
        rectanglePath.closePath()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
}
