//
//  CNLRatingView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 25/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public protocol CNLRatingViewDelegate: class {
    func ratingView(view: CNLRatingView, didChangeRatingTo rating: Int)
}

public class CNLRatingView: UIView {
    
    public var starsCount = 5
    public var starSize: CGFloat = 20.0
    public var starIdent: CGFloat = 10.0
    
    public var starImage: UIImage? {
        didSet {
            starImageViews.forEach {
                $0.image = starImage
            }
        }
    }
    public var starSelectedImage: UIImage? {
        didSet {
            starSelectedImageViews.forEach {
                $0.image = starSelectedImage
            }
        }
    }
    
    public var starImageViews: [UIImageView] = []
    public var starSelectedImageViews: [UIImageView] = []
    public var tapGestureRecognizer = UITapGestureRecognizer()
    
    weak public var delegate: CNLRatingViewDelegate?
    
    public var rating: Int = 0 {
        didSet {
            if oldValue != rating {
                delegate?.ratingView(view: self, didChangeRatingTo: rating)
                UIView.animate(withDuration: 0.2) {
                    if oldValue < self.rating {
                        // show new
                        for index in oldValue..<self.rating {
                            self.starSelectedImageViews[index].alpha = 1.0
                        }
                    } else {
                        // hide
                        for index in self.rating..<oldValue {
                            self.starSelectedImageViews[index].alpha = 0.0
                        }
                    }
                }
            }
        }
    }
    
    func tapGestureDetected(_ sender: AnyObject) {
        let point = tapGestureRecognizer.location(in: self)
        for index in 0..<starsCount {
            if starImageViews[index].frame.contains(point) {
                rating = index + 1
            }
        }
    }
    
    override public func layoutSubviews() {
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        for index in 0..<starsCount {
            let rect = CGRect(
                x: center.x + (starSize + starIdent) * (CGFloat(index) - CGFloat(starsCount) / 2.0) + starIdent / 2.0,
                y: center.y - starSize / 2.0,
                width: starSize,
                height: starSize
            )
            starImageViews[index].frame = rect
            starSelectedImageViews[index].frame = rect
        }
    }
    
    func internalInit() {
        for _ in 0..<starsCount {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFill
            starImageViews.append(starImageView)
            addSubview(starImageView)
            
            UIImageView() --> {
                $0.contentMode = .scaleAspectFill
                $0.alpha = 0.0
                self.starSelectedImageViews.append($0)
                self.addSubview($0)
            }
        }
        isUserInteractionEnabled = true
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureDetected(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }
    
    convenience public init() {
        self.init(frame: CGRect.zero)
        internalInit()
    }
    
}
