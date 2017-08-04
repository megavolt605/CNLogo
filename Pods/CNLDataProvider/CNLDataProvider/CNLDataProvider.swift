//
//  CNLDataProvider.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

/// Common data provider
public protocol CNLDataProvider: class {
    /// Associated model type with the provider
    associatedtype ModelType: CNLModelObject, CNLDataSourceModel
    
    /// Datasource proxy object for the provider
    var dataSource: CNLDataSource<ModelType>! { get set }

    /// Data viewer (table view, collection view or what ever)
    var dataViewer: CNLDataViewer { get }

    /// Provider state variables
    var dataProviderVariables: CNLDataProviderVariables<ModelType> { get set }
    
    /// Content state
    var contentState: CNLDataProviderContentState? { get set }

    /// Empty data set flag (read only)
    var noData: Bool { get }

    /// Updates visual content state (no data, no network, etc.)
    func updateContentState()

    /// Calculates current counts for sections, items with in sections
    func updateCounts()
    
    /// Called before new fetch
    func beforeFetch()

    /// Performs fetch new model objects from beginning
    ///
    /// - Parameter completed: Completion closure
    func fetchFromStart(completed: ((_ success: Bool) -> Void)?)

    /// Performs fetch next frame of model objects
    ///
    /// - Parameter completed: Completion closure
    func fetchNext(completed: ((_ success: Bool) -> Void)?)

    /// Called after fetch is completed
    func afterFetch()
    
    /// Number of sections (read only)
    var sectionCount: Int { get }

    /// Returns number of model items in the section
    ///
    /// - Parameter section: Section index
    func itemCountInSection(section: Int) -> Int
    
    /// Returns section index for the model item
    ///
    /// - Parameter item: Model item
    /// - Returns: Section index
    func sectionForItem(item: ModelType.ArrayElement) -> Int

    /// Returns display text for the section in witch model item belongs to
    ///
    /// - Parameter item: Model item
    /// - Returns: Display text
    func sectionTextForItem(item: ModelType.ArrayElement) -> String
    
    /// Returns model item for the index path
    ///
    /// - Parameter indexPath: Index path for item
    /// - Returns: Model item
    func itemAtIndexPath(indexPath: IndexPath) -> ModelType.ArrayElement?
    
    /// Returns index path for the model item
    ///
    /// - Parameter check: Model item
    /// - Returns: Index path of the item
    func indexPathOfItem(check: (_ modelItem: ModelType.ArrayElement) -> Bool) -> IndexPath?
    
    /// Returns array of index paths for model items array
    ///
    /// - Parameter check: Model items array
    /// - Returns: Array of index path for items array
    func indexPathsOfItems(check: (_ modelItem: ModelType.ArrayElement) -> Bool) -> [IndexPath]
    
    /// Basic initializer with data source instance.
    /// Usually called in viewDidLoad() function
    ///
    /// - Parameters:
    ///   - dataSource: Data source for the provider
    ///   - fetch: Perform initial fetch (invoke FullRefrsh())
    func initializeWith(dataSource: CNLDataSource<ModelType>, fetch: Bool)
}

// MARK: - Default implementations
public extension CNLDataProvider {
    
    /// Default implementation. True when data source model list have more than 0 items
    public var noData: Bool {
        return dataSource.model.list.count <= 0
    }
    
    /// Default implementation. Returns .noData when noData property is false, .normal otherwise
    public func updateContentState() {
        contentState?.kind = noData ? .noData : .normal
    }
    
    /// Default implementation. Get cached section title using sectionTextForItem(item:). Returns 0 if it not found
    ///
    /// - Parameter item: Model item
    /// - Returns: Section index
    public func sectionForItem(item: ModelType.ArrayElement) -> Int {
        let sectionText = sectionTextForItem(item: item)
        let res = dataProviderVariables.sectionTitles.index(of: sectionText) ?? 0
        return res
    }
    
    /// Default implementation. Returns empty string. Override it for your purposes.
    ///
    /// - Parameter item: Model item
    /// - Returns: Empty string
    public func sectionTextForItem(item: ModelType.ArrayElement) -> String {
        return ""
    }
    
    /// Default implementation. Cached section count
    public var sectionCount: Int {
        return dataProviderVariables.sectionIndexes.count
    }
    
    /// Default implementation. Cached item count in the section
    ///
    /// - Parameter section: Section index
    /// - Returns: Number of model items in the section
    public func itemCountInSection(section: Int) -> Int {
        let res = (dataProviderVariables.sectionIndexes[section] ?? []).count
        return res
    }
    
    /// Default implementation. Returns model item by index path
    ///
    /// - Parameter indexPath: Index path
    /// - Returns: Model item
    public func itemAtIndexPath(indexPath: IndexPath) -> ModelType.ArrayElement? {
        if let index = dataProviderVariables.dataSourceIndexForIndexPath(indexPath) {
            return dataSource.item(at: index)
        }
        return nil
    }
    
    /// Default implementation. Returns index path using conditional closure
    ///
    /// - Parameter check: Conditional closure. Returns Bool
    /// - Returns: Index path (Optional)
    public func indexPathOfItem(check: (_ modelItem: ModelType.ArrayElement) -> Bool) -> IndexPath? {
        for (sectionIndex, section) in dataProviderVariables.sectionIndexes.enumerated() {
            for (itemIndex, modelItemIndex) in section.1.enumerated() {
                let modelItem = dataSource.allItems[modelItemIndex]
                if check(modelItem) {
                    return dataViewer.createIndexPath(item: itemIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    /// Default implementation. Returns array of index paths using conditional closure
    ///
    /// - Parameter check: Conditional closure. Returns Bool
    /// - Returns: Result array of index path for all model items that applies conditional closure call
    public func indexPathsOfItems(check: (_ modelItem: ModelType.ArrayElement) -> Bool) -> [IndexPath] {
        var res: [IndexPath] = []
        for (sectionIndex, section) in dataProviderVariables.sectionIndexes.enumerated() {
            for (itemIndex, modelItemIndex) in section.1.enumerated() {
                let modelItem = dataSource.allItems[modelItemIndex]
                if check(modelItem) {
                    res.append(dataViewer.createIndexPath(item: itemIndex, section: sectionIndex))
                }
            }
        }
        return res
    }
    
    /// Returns array of index path with all items
    ///
    /// - Returns: Result array
    fileprivate func sectionRowIndexes() -> [IndexPath] {
        return dataProviderVariables.sectionIndexes.flatMap { section, items in
            return items.enumerated().map { (index, item) in
                return self.dataViewer.createIndexPath(item: index, section: section)
            }
        }
    }
    
    /// Returns index set for all sections
    ///
    /// - Returns: Result index set
    fileprivate func sectionIndexes() -> IndexSet {
        var res = IndexSet()
        dataProviderVariables.sectionIndexes.forEach { section, _ in res.insert(section) }
        return res
    }
    
    /// Default implementation. Update cached section information based on current data source values
    fileprivate func updateSetcions() {
        dataProviderVariables.sectionTitles = []
        dataSource.forEach { item in
            let text = sectionTextForItem(item: item)
            if !self.dataProviderVariables.sectionTitles.contains(text) {
                self.dataProviderVariables.sectionTitles.append(text)
            }
        }
    }
    
    /// Default implementation. Does nothing
    public func beforeFetch() { }
    
    /// Default implementation. Does nothing
    public func afterFetch() { }
    
    /// Default implementation. Fetch model items from the data source from the beginning
    ///
    /// - Parameter completed: Completion callback
    public func fetchFromStart(completed: ((_ success: Bool) -> Void)? = nil) {
        beforeFetch()
        dataSource.model.pagingReset()
        dataSource.model.update(
            success: { _, _ in
                self.updateDataViewer { isCompleted in
                    DispatchQueue.main.async {
                        self.updateContentState()
                        completed?(isCompleted)
                    }
                }
        },
            failed: { _, _ in
                completed?(false)
        }
        )
    }
    
    /// Default implementation. Fetch next frame of model items from the data source
    ///
    /// - Parameter completed: Completion closure
    public func fetchNext(completed: ((_ success: Bool) -> Void)?) {
        dataSource.model.fromIndex = dataSource.count - dataSource.model.additionalRecords
        if (dataSource.model.fromIndex != 0) && !dataProviderVariables.isFetching {
            dataProviderVariables.isFetching = true
            beforeFetch()
            dataSource.model.update(
                success: { _, _ in
                    self.updateDataViewerPage { isCompleted in
                        self.updateContentState()
                        completed?(isCompleted)
                        self.dataProviderVariables.isFetching = false
                    }
            },
                failed: { _, _ in
                    completed?(false)
                    self.dataProviderVariables.isFetching = false
            }
            )
        }
    }
    
    /// Default implementation. Refresh all data. Calls frtchFromStart(completion:)
    ///
    /// - Parameter showActivity: Show view activity if self is implemented CNLCanShowViewActivity protocol
    public func fullRefresh(showActivity: Bool = true) {
        if let canShowViewActivity = self as? CNLCanShowViewAcvtitity, showActivity {
            canShowViewActivity.startViewActivity(nil, completion: nil)
        }
        self.fetchFromStart { _ in
            if let canShowViewActivity = self as? CNLCanShowViewAcvtitity, showActivity {
                DispatchQueue.main.async {
                    canShowViewActivity.finishViewActivity()
                }
            }
        }
    }
    
    /// Default implementation. Updates data viewer after fetchFromStart
    ///
    /// - Parameter completed: Completion callback
    public func updateDataViewer(completed: ((_ success: Bool) -> Void)? = nil) {
        self.dataViewer.batchUpdates(
            updates: {
                let savedSectionIndexes = self.sectionIndexes()
                let savedSectionRowIndexes = self.sectionRowIndexes()
                self.dataSource.reset()
                self.dataSource.requestCompleted()
                self.updateSetcions()
                #if DEBUG
                    do {
                        let info = savedSectionIndexes
                            .map { return $0.toString }
                            .joined(separator: ",")
                        CNLLog("Delete Section\n\(info)", level: .debug)
                    }
                #endif
                self.dataViewer.deleteSections(savedSectionIndexes as IndexSet)
                #if DEBUG
                    do {
                        let info = savedSectionRowIndexes
                            .map { return "\($0.section) - \($0.row)" }
                            .joined(separator: ",")
                        CNLLog("Delete Rows\n\(info)", level: .debug)
                    }
                #endif
                self.dataViewer.deleteItemsAtIndexPaths(savedSectionRowIndexes)
                
                self.updateCounts()
                
                #if DEBUG
                    do {
                        let info = self.sectionIndexes()
                            .map { return $0.toString }
                            .joined(separator: ",")
                        CNLLog("Insert Section\n\(info)", level: .debug)
                    }
                #endif
                self.dataViewer.insertSections(self.sectionIndexes())
                #if DEBUG
                    do {
                        let info = self.sectionRowIndexes()
                            .map { return "\($0.section) - \($0.row)" }
                            .joined(separator: ",")
                        CNLLog("Insert Rows\n\(info)", level: .debug)
                    }
                #endif
                self.dataViewer.insertItemsAtIndexPaths(self.sectionRowIndexes())
                self.dataViewer.reloadData()
            },
            completion: { _ in
                self.afterFetch()
                completed?(true)
            }
        )
    }
    
    /// Default implementation. Updates data viewer after fetchNext
    ///
    /// - Parameter completed: Completion callback
    public func updateDataViewerPage(completed: ((_ success: Bool) -> Void)?) {
        let savedSections = self.dataProviderVariables.sectionIndexes
        let savedLoadMore = self.dataProviderVariables.loadMore
        
        self.dataSource.requestCompleted()
        self.updateSetcions()
        self.updateCounts()
        
        // append new sections
        var newSectionIndexes = IndexSet()
        var newRowIndexes: [IndexPath] = []
        self.dataProviderVariables.sectionIndexes.forEach { section, items in
            if let oldSection = savedSections[section] {
                items.enumerated().forEach { index, item in
                    if !oldSection.contains(item) {
                        if !savedLoadMore.visible || (section != savedLoadMore.section) || (index != 0) {
                            newRowIndexes.append(self.dataViewer.createIndexPath(item: index, section: section))
                        }
                    }
                }
            } else {
                if savedLoadMore.visible || (section != savedLoadMore.section) {
                    newSectionIndexes.insert(section)
                    items.enumerated().forEach { index, item in
                        newRowIndexes.append(self.dataViewer.createIndexPath(item: index, section: section))
                    }
                }
            }
        }
        #if DEBUG
            do {
                let info1 = newSectionIndexes
                    .map { return $0.toString }
                    .joined(separator: ",")
                CNLLog("PInsert Section\n\(info1)", level: .debug)
                let info2 = newRowIndexes
                    .map { return "\($0.section) - \($0.row)" }
                    .joined(separator: ",")
                CNLLog("PInsert Rows\n\(info2)", level: .debug)
            }
        #endif
        
        UIView.setAnimationsEnabled(false)
        self.dataViewer.batchUpdates(
            updates: {
                if savedLoadMore.visible && !self.dataProviderVariables.loadMore.visible {
                    let loadMoreSectionExists = self.dataProviderVariables.sectionIndexes[savedLoadMore.section] == nil
                    let loadMoreSectionEmpty = self.dataProviderVariables.sectionIndexes[savedLoadMore.section]?.count == 0
                    if loadMoreSectionExists || loadMoreSectionEmpty {
                        let indexPath = self.dataViewer.createIndexPath(item: 0, section: savedLoadMore.section)
                        self.dataViewer.deleteItemsAtIndexPaths([indexPath])
                        self.dataViewer.deleteSections(IndexSet([savedLoadMore.section]))
                    }
                }
                #if DEBUG
                    do {
                        let info = newSectionIndexes
                            .map { $0.toString }
                            .joined(separator: ",")
                        CNLLog("Insert Section\n\(info)", level: .debug)
                    }
                #endif
                
                self.dataViewer.insertSections(newSectionIndexes)
                
                #if DEBUG
                    do {
                        let info = newRowIndexes
                            .map { return "\($0.section) - \($0.row), " }
                            .joined(separator: ",")
                        CNLLog("Insert Rows\n\(info)", level: .debug)
                    }
                #endif
                self.dataViewer.insertItemsAtIndexPaths(newRowIndexes)
            },
            completion: { _ in
                UIView.setAnimationsEnabled(true)
                self.afterFetch()
                completed?(true)
            }
        )
    }
    
    /// Default implementation. Initialize data provider with data source and assotiated model type
    ///
    /// - Parameters:
    ///   - dataSource: Data source instance
    ///   - fetch: Perform initial fetch flag (calls fullRefresh())
    public func initializeWith(dataSource: CNLDataSource<ModelType>, fetch: Bool = true) {
        dataViewer.initializeCells()
        self.dataSource = dataSource
        fullRefresh()
    }
    
    /// Collect section/items count information for cache purposes
    ///
    /// - Returns: Calculated values
    fileprivate func updateCountsCollectItems() -> [Int:[Int]] {
        var res: [Int:[Int]] = [:]
        dataProviderVariables.loadMore.section = 0
        for (index, item) in dataSource.allItems.enumerated() {
            let section = sectionForItem(item: item)
            var items = res[section] ?? []
            items.append(index)
            res[section] = items
            if dataSource.model.isPagingEnabled {
                dataProviderVariables.loadMore.section = max(dataProviderVariables.loadMore.section, section + 1)
            }
        }
        if !(dataSource.model.isPagingEnabled) {
            dataProviderVariables.loadMore.visible = false
        }
        return res
    }
    
    /// Default implementation.
    /// Update cached counts for sections, manages visibility flag for artifical "load more" section and item
    public func updateCounts() {
        let totalCount = dataSource.model.totalRecords
        let additionalCount = dataSource.model.additionalRecords
        dataProviderVariables.loadMore.visible = dataSource.model.isPagingEnabled && ((totalCount == nil) || ((dataSource.count - additionalCount) != totalCount))
        
        var res = updateCountsCollectItems()
        if dataProviderVariables.loadMore.visible { res[dataProviderVariables.loadMore.section] = [0] }
        dataProviderVariables.sectionIndexes = res
    }
    
}
