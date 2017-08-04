//
//  CNLUIT+UINavigationController.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    public func customPush(
        _ viewController: UIViewController,
        flowView: UIView? = nil,
        flowImage: UIImage? = nil,
        baseView: UIView? = nil,
        transitionType: String = kCATransitionPush,
        subtype: String = kCATransitionFromRight
        ) {
        
        let transition: () -> Void = {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = transitionType
            transition.subtype = subtype
            
            self.view.layer.add(transition, forKey: kCATransition)
            self.pushViewController(viewController, animated: false)
        }
        
        if let flowView = flowView, let baseView = baseView {
            let frame = flowView.convert(flowView.bounds, to: baseView)
            
            let imageView = UIImageView(frame: frame)
            imageView.image = flowImage ?? flowView.snapshot()
            baseView.addSubview(imageView)
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    imageView.layer.transform = CATransform3DMakeScale(2.0, 2.0, 1.0)
                    imageView.alpha = 0.1
                    imageView.center = baseView.bounds.center
                },
                completion: { _ in
                    imageView.removeFromSuperview()
                    transition()
                }
            )
        } else {
            transition()
        }
        
    }

    public func pushViewController(
        viewController: UIViewController,
        duration: CFTimeInterval = 0.2,
        timingFunction: String = kCAMediaTimingFunctionLinear,
        type: String = kCATransitionPush,
        subtype: String = kCATransitionFromRight
        ) {
        
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction)
        transition.type = type
        transition.subtype = subtype
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    public func popViewController(duration: CFTimeInterval = 0.2, timingFunction: String = kCAMediaTimingFunctionLinear, type: String = kCATransitionPush, subtype: String = kCATransitionFromRight) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction)
        transition.type = type
        transition.subtype = subtype
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }

}
