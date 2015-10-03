//
//  CNMainMenuController.swift
//  CNLogo
//
//  Created by Igor Smirnov on 03/10/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNButton: UIButton {
    
    func setupButtonImage(image: UIImage?) {
        let newImage = image?.imageWithColor(UIColor.whiteColor())
        setImage(newImage, forState: .Normal)
        setImage(newImage, forState: .Highlighted)
    }
    
    func setupButtonColors(backColor backColor: UIColor, borderColor: UIColor) {
        imageEdgeInsets = UIEdgeInsetsMake(bounds.width / 4.0, bounds.width / 4.0, bounds.width / 4.0, bounds.width / 4.0)
        backgroundColor = backColor
        layer.cornerRadius = bounds.width / 2.0
        layer.shadowOffset = CGSizeMake(2.0, 2.0)
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.5
        layer.borderColor = borderColor.colorWithAlphaComponent(0.75).CGColor
        layer.borderWidth = 1.0
        //layer.masksToBounds = true
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                if oldValue != highlighted {
                    layer.shadowOffset = CGSizeZero
                    frame.origin = frame.offsetBy(dx: 1.0, dy: 1.0).origin
                    layer.shadowRadius = 1.0
                }
            } else {
                if oldValue != highlighted {
                    layer.shadowOffset = CGSizeMake(2.0, 2.0)
                    frame.origin = frame.offsetBy(dx: -1.0, dy: -1.0).origin
                    layer.shadowRadius = 3.0
                }
            }
        }
    }

}