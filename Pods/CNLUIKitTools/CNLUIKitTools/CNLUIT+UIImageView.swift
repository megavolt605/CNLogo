//
//  CNLUIT+UIImageView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func makeMeRounded(_ borderWidth: CGFloat = 3.0, borderColor: UIColor? = nil) {
        layer.cornerRadius = frame.width / 2.0
        clipsToBounds = true
        if borderWidth > 0.0 {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor?.cgColor ?? UIColor.white.cgColor
        }
    }
    
}
