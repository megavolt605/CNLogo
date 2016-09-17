//
//  CNMainMenuController.swift
//  CNLogo
//
//  Created by Igor Smirnov on 03/10/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNButton: UIButton {
    
    func setupButtonImage(_ image: UIImage?) {
        let newImage = image?.imageWithColor(UIColor.white)
        setImage(newImage, for: UIControlState())
        setImage(newImage, for: .highlighted)
    }
    
    func setupButtonColors(backColor: UIColor, borderColor: UIColor) {
        imageEdgeInsets = UIEdgeInsetsMake(bounds.width / 4.0, bounds.width / 4.0, bounds.width / 4.0, bounds.width / 4.0)
        backgroundColor = backColor
        layer.cornerRadius = bounds.width / 2.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.borderColor = borderColor.withAlphaComponent(0.75).cgColor
        layer.borderWidth = 1.0
        //layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                if oldValue != isHighlighted {
                    layer.shadowOffset = CGSize.zero
                    frame.origin = frame.offsetBy(dx: 1.0, dy: 1.0).origin
                    layer.shadowRadius = 1.0
                }
            } else {
                if oldValue != isHighlighted {
                    layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                    frame.origin = frame.offsetBy(dx: -1.0, dy: -1.0).origin
                    layer.shadowRadius = 3.0
                }
            }
        }
    }

}
