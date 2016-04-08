//
//  CNLogoCore+String.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 12/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public extension String {

    var integerValue: Int {
        return (self as NSString).integerValue
    }

    var doubleValue: Double {
        return (self as NSString).doubleValue
    }

}