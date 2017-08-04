//
//  CNLUIT+UITableView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public extension UITableView {
    
    public func cellIsCompletlyVisible(_ cell: UITableViewCell) -> Bool {
        if let indexPath = indexPath(for: cell) {
            let cellRect = convert(rectForRow(at: indexPath), to: superview)
            return frame.contains(cellRect)
        } else {
            return false
        }
    }
    
}
