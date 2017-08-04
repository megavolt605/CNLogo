//
//  CNLLabel.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 27/04/2017.
//  Copyright © 2017 Complex Numbers. All rights reserved.
//

import UIKit

open class CNLLabel: UILabel {
    
    open var topInset: CGFloat = 0.0
    open var bottomInset: CGFloat = 0.0
    open var leftInset: CGFloat = 0.0
    open var rightInset: CGFloat = 0.0
    
    override open func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override open var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
