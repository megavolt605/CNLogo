//
//  CNLTabBarController.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 19/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

open class CNLTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let tabViewControllers = tabBarController.viewControllers,
            let fromView = tabBarController.selectedViewController?.view,
            let fromViewController = tabBarController.selectedViewController,
            let fromIndex = tabViewControllers.index(of: fromViewController),
            let toView = viewController.view,
            let toIndex = tabViewControllers.index(of: viewController),
            fromView != toView
            else { return false }
        
        UIView.transition(
            from: fromView,
            to:toView,
            duration:0.3,
            options: (toIndex > fromIndex) ? .transitionFlipFromLeft : .transitionFlipFromRight,
            completion: { finished in
                if finished {
                    tabBarController.selectedIndex = toIndex
                }
            }
        )
        return true
    }
    
}
