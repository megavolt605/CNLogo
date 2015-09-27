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
            contentView.setNeedsDisplay()
        }

        /*
        let shiftImage = UIImage(named: "block_shift")
        (0..<item.level).forEach { index in
            if index != 0 || item.startIndex == nil {
                let imageView = UIImageView(frame: CGRectMake(x, 0.0, 10.0, contentView.bounds.height))
                imageView.image = shiftImage
                contentView.addSubview(imageView)
                x += 12.0
            }
        }
        
        if item.block.statements.count > 0 {
            
            let startImage: UIImage?
            if item.startIndex == nil {
                startImage = UIImage(named: "block_start")
            } else {
                startImage = UIImage(named: "block_end")
            }
            let imageView = UIImageView(frame: CGRectMake(x, 0.0, 20.0, contentView.bounds.height))
            imageView.image = startImage
            contentView.addSubview(imageView)
            x += 12.0
            
            
            let fillImage = UIImage(named: "block")
            let imageBackView = UIImageView(frame: CGRectMake(x, 0.0, contentView.bounds.width - x, contentView.bounds.height))
            imageBackView.layer.magnificationFilter = kCAFilterNearest
            imageBackView.image = fillImage
            contentView.addSubview(imageBackView)
            
            /*
            let fillImage = UIImage(named: "block")?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0))
            let backView = UIImageView(frame: CGRectMake(x, 0.0, contentView.bounds.width - x, contentView.bounds.height))
            backView.backgroundColor = UIColor(patternImage: fillImage!)
            contentView.addSubview(backView)
            */
        }
        
        let cellText = UILabel(frame: CGRectMake(x, 0, contentView.bounds.width - x, contentView.bounds.height))
        cellText.font = UIFont.systemFontOfSize(8.0)
        cellText.text = (item.startIndex == nil ? "" : "End of ") + item.block.description
        contentView.addSubview(cellText)
        */
    }
    
    override func prepareForReuse() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
