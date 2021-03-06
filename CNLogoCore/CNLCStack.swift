//
//  CNLCStack.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public struct CNLCStack<T> {
    
    fileprivate var items: [T] = []
    
    mutating func push(_ value: T) {
        items.append(value)
    }
    
    mutating func pop() -> T? {
        let res = items.last
        items.removeLast()
        return res
    }
    
    func peek() -> T? {
        return items.last
    }
    
    var count: Int {
        return items.count
    }
    
    
}
