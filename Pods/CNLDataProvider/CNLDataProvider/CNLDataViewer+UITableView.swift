//
//  CNLDataViewer+UITableView.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLUIKitTools

extension UITableView: CNLDataViewer {
    
    public var ownerViewController: UIViewController? {
        return parentViewController
    }
    
    public var loadMoreCellType: AnyClass {
        return CNLTableViewLoadMoreCell.self
    }
    
    public subscript (indexPath: IndexPath) -> CNLDataViewerCell {
        let identifier = cellType?(indexPath)?.cellIdentifier ?? "Cell"
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CNLDataViewerCell // swiftlint:disable:this force_cast
    }
    
    public subscript (cellIdentifier: String?, indexPath: IndexPath) -> CNLDataViewerCell {
        let identifier = cellIdentifier ?? cellType?(indexPath)?.cellIdentifier ?? "Cell"
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CNLDataViewerCell // swiftlint:disable:this force_cast
    }
    
    public func loadMoreCell(_ indexPath: IndexPath) -> CNLDataViewerLoadMoreCell {
        return dequeueReusableCell(withIdentifier: "Load More Cell", for: indexPath) as! CNLDataViewerLoadMoreCell // swiftlint:disable:this force_cast
    }
    
    public func initializeCells() {
        register(loadMoreCellType, forCellReuseIdentifier: "Load More Cell")
    }
    
    public func batchUpdates(_ updates: @escaping () -> Void) {
        beginUpdates()
        updates()
        endUpdates()
    }
    
    public func batchUpdates(updates: @escaping () -> Void, completion: @escaping (_ isCompleted: Bool) -> Void) {
        beginUpdates()
        updates()
        endUpdates()
        completion(true)
    }
    
    public func insertSections(_ indexes: IndexSet) {
        insertSections(indexes, with: .fade)
    }
    
    public func insertItemsAtIndexPaths(_ indexes: [IndexPath]) {
        insertRows(at: indexes, with: .fade)
    }
    
    public func deleteSections(_ indexes: IndexSet) {
        deleteSections(indexes, with: .none)
    }
    
    public func deleteItemsAtIndexPaths(_ indexes: [IndexPath]) {
        deleteRows(at: indexes, with: .none)
    }
    
    public func reloadSections(_ sections: IndexSet, withRowAnimation animation: CNLDataViewerCellAnimation) {
        reloadSections(sections, with: animation.tableViewRowAnimation)
    }
    
    public func reloadItemsAtIndexPaths(_ indexes: [IndexPath], withAnimation animation: CNLDataViewerCellAnimation) {
        reloadRows(at: indexes, with: animation.tableViewRowAnimation)
    }
    
    public func selectItemAtIndexPath(_ indexPath: IndexPath, animated: Bool, scrollPosition position: CNLDataViewerScrollPosition) {
        selectRow(at: indexPath, animated: animated, scrollPosition: position.tableViewScrollPosition)
    }
    
    public func notifyDelegateDidSelectItemAtIndexPath(_ indexPath: IndexPath) {
        delegate?.tableView!(self, didSelectRowAt: indexPath)
    }
    
    public func selectedItemPaths() -> [IndexPath] {
        return selectedItemPaths()
    }
    
    public func scrollToIndexPath(_ indexPath: IndexPath, atScrollPosition position: CNLDataViewerScrollPosition, animated: Bool) {
        scrollToRow(at: indexPath, at: position.tableViewScrollPosition, animated: animated)
    }
    
    func nonEmptySections() -> [Int] {
        return (0..<numberOfSections).filter { return self.numberOfRows(inSection: $0) > 0 }
    }
    
    public func scrollToTop(_ animated: Bool = true) {
        let sections = nonEmptySections()
        if let section = sections.first {
            scrollToRow(
                at: IndexPath(row: 0, section: section),
                at: UITableViewScrollPosition.top,
                animated: animated
            )
        }
    }
    
    public func scrollToBottom(_ animated: Bool = true) {
        let sections = nonEmptySections()
        if let section = sections.last {
            let rowCount = numberOfRows(inSection: section)
            scrollToRow(
                at: IndexPath(row: rowCount - 1, section: section),
                at: UITableViewScrollPosition.top,
                animated: true
            )
        }
    }
    
    public func deselectAll(_ animated: Bool = true) {
        let items = (0..<numberOfSections).flatMap { section in
            return (0..<self.numberOfRows(inSection: section)).map {
                return IndexPath(row: section, section: $0)
            }
        }
        
        for item in items {
            deselectRow(at: item, animated: animated)
        }
    }
    
    public func createIndexPath(item: Int, section: Int) -> IndexPath {
        return IndexPath(row: item, section: section)
    }
    
    // Cells
    public func cellForItemAtIndexPath<T: CNLDataProvider>(
        _ dataProvider: T,
        cellIdentifier: String?,
        indexPath: IndexPath,
        context: CNLModelObject?
        ) -> AnyObject where T.ModelType : CNLDataSourceModel, T.ModelType.ArrayElement : CNLModelObject {
        
        if dataProvider.dataProviderVariables.isLoadMoreIndexPath(indexPath) {
            let cell = loadMoreCell(indexPath)
            cell.setupCell(self, indexPath: indexPath)
            if  dataProvider.dataSource.model.isPagingEnabled {
                dataProvider.fetchNext(completed: nil)
            }
            return cell as! UITableViewCell // swiftlint:disable:this force_cast
        } else {
            let cell = self[cellIdentifier, indexPath]
            if let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
                cell.setupCell(self, indexPath: indexPath, cellInfo: item, context: context)
            }
            return cell as! UITableViewCell // swiftlint:disable:this force_cast
        }
    }
    
    public func cellSizeForItemAtIndexPath<T: CNLDataProvider>(_ dataProvider: T, indexPath: IndexPath, context: CNLModelObject?) -> CGFloat where T.ModelType.ArrayElement: CNLModelObject {
        if dataProvider.dataProviderVariables.isLoadMoreIndexPath(indexPath) {
            return CNLTableViewLoadMoreCell.cellSize(self, indexPath: indexPath).height
        } else {
            if let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
                return cellType?(indexPath)?.cellSize(self, indexPath: indexPath, cellInfo: item, context: context).height ?? 0
            }
        }
        return 0
    }
    
    // Headers
    public func createHeader<T: CNLDataProvider>(_ dataProvider: T, section: Int) -> UIView? where T.ModelType: CNLModelArray, T.ModelType.ArrayElement: CNLModelObject {
        let indexPath = createIndexPath(item: 0, section: section)
        if let currentHeaderType = headerType?(section), let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
            let height = currentHeaderType.headerHeight(self, section: section, cellInfo: item)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: height))
            let headerText = dataProvider.sectionTextForItem(item: item)
            currentHeaderType.setupHeader(self, view: view, section: section, cellInfo: item, headerText: headerText)
            return view
        }
        return nil
    }
    
    public func headerHeight<T: CNLDataProvider>(_ dataProvider: T, section: Int) -> CGFloat where T.ModelType: CNLModelArray, T.ModelType.ArrayElement: CNLModelObject {
        if dataProvider.dataProviderVariables.loadMore.section == section, dataProvider.dataProviderVariables.loadMore.visible {
            return 0
        }
        let indexPath = createIndexPath(item: 0, section: section)
        if let currentHeaderType = headerType?(section), let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
            return currentHeaderType.headerHeight(self, section: section, cellInfo: item)
        }
        return 0
    }
    
}

open class CNLTableViewLoadMoreCell: UITableViewCell, CNLDataViewerLoadMoreCell {
    
    open var activity: CNLDataViewerActivity?
    open var createActivity: () -> CNLDataViewerActivity? = { _ in return nil }
    open var verticalInset: CGFloat = 0.0
    
    open func setupCell<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) where T : UIView {
        contentView.backgroundColor = UIColor.clear
        activity = createActivity()
        if let activity = activity as? UIView {
            let centerX = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
            let height = NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: -verticalInset)
            let proportion = NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: activity, attribute: .width, multiplier: 1.0, constant: 0.0)
            contentView.addSubview(activity)
            contentView.addConstraints([centerX, height])
            activity.addConstraint(proportion)
        }
    }
    
    static open func cellSize<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) -> CGSize where T: UIView {
        return CGSize(width: 0, height: 40)
    }
    
}
