//
//  CNLUIT+UIBarButtonItem.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 28/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public extension UIBarButtonItem {
    
    convenience init(withImage image: UIImage?, target: Any, selector: Selector) {
        self.init(customView:
            UIButton(type: .custom) --> {
                $0.setImage(image, for: .normal)
                $0.addTarget(target, action: selector, for: .touchUpInside)
                $0.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
            }
        )
    }
    
}
