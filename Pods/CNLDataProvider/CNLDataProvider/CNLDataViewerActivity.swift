//
//  CNLDataViewerActivity.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public protocol CNLDataViewerActivity {
    
    var frame: CGRect { get set }
    
    var isAnimating: Bool { get }
    
    var view: UIView { get }
    
    func startAnimating()
    func stopAnimating()
    
}

public protocol CNLDataViewerRefreshControlProtocol {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}

open class CNLDataViewerRefreshControl {
    
    open var refreshControl: UIRefreshControl!
    open var activity: CNLDataViewerActivity!
    open var isAnimating = false
    open var action: () -> Void
    
    open var animationFrame: CGRect {
        let bounds = refreshControl.frame
        let height = bounds.height * 0.75
        let origin = CGPoint(x: bounds.midX - height / 2.0, y: bounds.midY - height / 2.0)
        let size = CGSize(width: height, height: height)
        return CGRect(origin: origin, size: size)
    }
    
    open func startAnimating() {
        if refreshControl.isRefreshing {
            if !isAnimating {
                isAnimating = true
                refreshControl.layer.removeAllAnimations()
                refreshControl.isHidden = true
                refreshControl.tintColor = UIColor.clear
                action()
                activity?.frame = animationFrame
                refreshControl.superview?.addSubview(activity.view)
                activity?.startAnimating()
            }
        }
    }
    
    open func stopAnimating() {
        if isAnimating {
            isAnimating = false
            refreshControl.endRefreshing()
            refreshControl.tintColor = UIColor.white
            refreshControl.isHidden = false
            activity?.stopAnimating()
            activity?.view.removeFromSuperview()
        }
    }
    
    public init<T: CNLDataProvider>(dataProvider: T, color: UIColor, activity: CNLDataViewerActivity, action: @escaping () -> Void) where T: CNLDataViewerRefreshControlProtocol {
        self.action = action
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.white
        dataProvider.dataViewer.addSubview(refreshControl)
        self.activity = activity
    }
    
}

public typealias CNLRefreshableScrollViewAction = (_ success: Bool) -> Void
public typealias CNLRefreshableScrollViewBeforeRefresh = () -> Bool

public protocol CNLRefreshableScrollView: UIScrollViewDelegate {
    
    var refreshControl: CNLDataViewerRefreshControl? { get set }
    
    func initializeRefresher<T: CNLDataProvider>(
        _ dataProvider: T,
        color: UIColor,
        activity: CNLDataViewerActivity,
        beforeRefresh: CNLRefreshableScrollViewBeforeRefresh?,
        action: CNLRefreshableScrollViewAction?
        ) where T: CNLDataViewerRefreshControlProtocol
}

fileprivate var refreshControlVar = "refreshControlVar"
fileprivate var notificationObserverVar = "notificationObserver"

extension CNLRefreshableScrollView where Self: CNLDataProvider {
    
    public var refreshControl: CNLDataViewerRefreshControl? {
        get {
            if let value = (objc_getAssociatedObject(self, &refreshControlVar) as? CNLAssociated<CNLDataViewerRefreshControl?>)?.closure {
                return value
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &refreshControlVar, CNLAssociated<CNLDataViewerRefreshControl?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var notificationObserver: AnyObject? {
        get {
            if let value = (objc_getAssociatedObject(self, &notificationObserverVar) as? CNLAssociated<AnyObject?>)?.closure {
                return value
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &notificationObserverVar, CNLAssociated<AnyObject?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func registerRefreshNotifications(withName name: String) {
        notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: nil) { _ in
            self.refreshControl?.action()
        }
    }
    
    public func removeRefreshNotifications() {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    public func initializeRefresher<T: CNLDataProvider>(
        _ dataProvider: T,
        color: UIColor,
        activity: CNLDataViewerActivity,
        beforeRefresh: CNLRefreshableScrollViewBeforeRefresh? = nil,
        action: CNLRefreshableScrollViewAction? = nil
        ) where T: CNLDataViewerRefreshControlProtocol {
        
        refreshControl = CNLDataViewerRefreshControl(
            dataProvider: dataProvider,
            color: color,
            activity: activity,
            action: {
                if beforeRefresh?() ?? true {
                    self.fetchFromStart { completed in
                        self.refreshControl?.stopAnimating()
                        action?(completed)
                    }
                }
            }
        )
    }
    
}
