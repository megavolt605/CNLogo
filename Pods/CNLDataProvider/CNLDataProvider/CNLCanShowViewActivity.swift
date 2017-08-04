//
//  CNLCanShowViewActivity.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

/// Protocol for views and view controllers that have possibility to show (and possibly to animate) long activity (for example: network requests lags, etc.)
public protocol CNLCanShowViewAcvtitity {
    /// Starts visual activity
    ///
    /// - Parameters:
    ///   - closure: Long operation closure
    ///   - completion: Completion callback
    func startViewActivity(_ closure: (() -> Void)?, completion: (() -> Void)?)

    /// Ends visual activity, if any
    func finishViewActivity()
}
