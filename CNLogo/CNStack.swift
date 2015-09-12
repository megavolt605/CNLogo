//
//  CNStack.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

struct CNStack<T> {
    
    private var items: [T] = []
    
    mutating func push(value: T) {
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