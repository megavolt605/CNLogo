//
//  CNVisualElements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 24/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNBubbleView: UIView {

    var text: String
    var color: UIColor
    var size: CGSize = CGSizeZero
    var bold: Bool
    var tiny = false
    
    internal var strSize: CGSize = CGSizeZero
    
    func textAttrs() -> [String: AnyObject] {
        return [
            NSFontAttributeName: bold ? UIFont.boldSystemFontOfSize(10.0) : UIFont.systemFontOfSize(10.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
    }
    
    func calcSize() {
        let str = NSString(string: text)
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin,
            attributes: textAttrs(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + (tiny ? -2.0 : 10.0), size.height - 1.0)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        let rectanglePath = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: size.height / 4.0)
        
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0 - 1.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
        self.calcSize()
    }
    
    init(text: String, color: UIColor, height: CGFloat, bold: Bool) {
        self.text = text
        self.color = color
        self.size.height = height
        self.bold = bold
        super.init(frame: CGRectZero)
        initialize()
    }
    
    init(text: String, color: UIColor, height: CGFloat, bold: Bool, tiny: Bool) {
        self.text = text
        self.color = color
        self.size.height = height
        self.bold = bold
        self.tiny = tiny
        super.init(frame: CGRectZero)
        initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
