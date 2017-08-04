//
//  CNLDataProviderVariables.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

public typealias CNLDataProviderVariablesLoadMore = (section: Int, visible: Bool)
public typealias CNLDataProviderSectionIndexes = [Int:[Int]]

public struct CNLDataProviderVariables<T: CNLDataSourceModel> {
    public typealias ModelType = T
    public var isFetching = false
    public var loadMore: CNLDataProviderVariablesLoadMore = (section: 0, visible: false)
    public var sectionTitles: [String] = []
    public var sectionIndexes: CNLDataProviderSectionIndexes = [:]
    
    public func isLoadMoreIndexPath(_ indexPath: IndexPath) -> Bool {
        return loadMore.visible && (indexPath as IndexPath).section == loadMore.section
    }
    
    public func dataSourceIndexForIndexPath(_ indexPath: IndexPath) -> Int? {
        if let index = sectionIndexes[(indexPath as IndexPath).section]?[(indexPath as IndexPath).row], !isLoadMoreIndexPath(indexPath) {
            return index
        }
        return nil
    }
    
    /// Default initializer
    public init() { }
    
}
