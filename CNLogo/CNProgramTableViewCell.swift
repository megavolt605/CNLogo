//
//  CNProgramTableViewCell.swift
//  CNLogo
//
//  Created by Igor Smirnov on 21/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNProgramTableViewCell: UITableViewCell {
    
    func setup(item: CNProgramTableViewItem) {
        var x: CGFloat = 0.0

        let shiftImage = UIImage(named: "statement")
        (0..<item.level).forEach { index in
            if index != 0 || item.startIndex == nil {
                let imageView = UIImageView(frame: CGRectMake(x, 0.0, 20.0, contentView.bounds.height))
                imageView.image = shiftImage
                contentView.addSubview(imageView)
                x += 12.0
            }
        }
        
        if item.block.statements.count > 0 {
            
            let startImage: UIImage?
            if item.startIndex == nil {
                startImage = UIImage(named: "statement_start")
            } else {
                startImage = UIImage(named: "statement_end")
            }
            let imageView = UIImageView(frame: CGRectMake(x, 0.0, 20.0, contentView.bounds.height))
            imageView.image = startImage
            contentView.addSubview(imageView)
            x += 12.0
        }
        
        let cellText = UILabel(frame: CGRectMake(x, 0, contentView.bounds.width - x, contentView.bounds.height))
        cellText.font = UIFont.systemFontOfSize(8.0)
        cellText.text = (item.startIndex == nil ? "" : "End of ") + item.block.description
        contentView.addSubview(cellText)
   
    }
    
    override func prepareForReuse() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
