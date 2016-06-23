//
//  CNProgramTableViewCell.swift
//  CNLogo
//
//  Created by Igor Smirnov on 21/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNProgramTableViewCell: UITableViewCell {
    
    static var defaultHeight: CGFloat = 16.0
    
    func setup(item: CNProgramTableViewItem, height: CGFloat) {
        var x: CGFloat = 5.0
        
        let bubbles = CNBubbleView.bubbleFor(item.block, height: height, prefix: item.startIndex == nil ? "" : "End of ")

        func addBubble(bubble: CNBubbleView) {
            bubble.frame = CGRect(origin: CGPointMake(x, 0), size: bubble.size)
            x += bubble.size.width + 2.0
            contentView.addSubview(bubble)
        }
        
        for index in 0..<item.level {
            if index != 0 || item.startIndex == nil {
                let bubble = CNBubbleBlockShiftView(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
                addBubble(bubble)
            }
        }
        
        if item.block.statements.count > 0 {
            let bubble: CNBubbleView
            if item.startIndex == nil {
                bubble = CNBubbleBlockStartView(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
            } else {
                bubble = CNBubbleBlockEndView(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
            }
            addBubble(bubble)
        }
        
        bubbles.forEach { addBubble($0) }
    }
    
    override func prepareForReuse() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
