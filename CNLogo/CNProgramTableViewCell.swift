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
        
        if let bubbles = item.block.createBubbles(height, prefix: item.startIndex == nil ? "" : "End of ") {

            func addBubble(bubble: CNBubble) {
                bubble.frame = CGRect(origin: CGPointMake(x, 0), size: bubble.size)
                x += bubble.size.width + 2.0
                contentView.addSubview(bubble)
            }
            
            (0..<item.level).forEach { index in
                if index != 0 || item.startIndex == nil {
                    let bubble = CNBubbleBlockShift(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
                    addBubble(bubble)
                }
            }
            
            if item.block.statements.count > 0 {
                let bubble: CNBubble
                if item.startIndex == nil {
                    bubble = CNBubbleBlockStart(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
                } else {
                    bubble = CNBubbleBlockEnd(text: "", color: UIColor.lightGrayColor(), height: height, bold: false)
                }
                addBubble(bubble)
            }
            
            for bubble in bubbles {
                addBubble(bubble)
            }
        }
    }
    
    override func prepareForReuse() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
