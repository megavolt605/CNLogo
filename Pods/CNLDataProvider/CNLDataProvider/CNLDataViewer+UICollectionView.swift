//
//  CNLDataViewer+UICollectionView.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

extension UICollectionView: CNLDataViewer {
    
    public var ownerViewController: UIViewController? {
        return parentViewController
    }
    
    public var loadMoreCellType: AnyClass {
        return CNLCollectionViewLoadMoreCell.self
    }
    
    public subscript (indexPath: IndexPath) -> CNLDataViewerCell {
        let identifier = cellType?(indexPath)?.cellIdentifier ?? "Cell"
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CNLDataViewerCell // swiftlint:disable:this force_cast
    }
    
    public subscript (cellIdentifier: String?, indexPath: IndexPath) -> CNLDataViewerCell {
        let identifier = cellIdentifier ?? cellType?(indexPath)?.cellIdentifier ?? "Cell"
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CNLDataViewerCell // swiftlint:disable:this force_cast
    }
    
    public func loadMoreCell(_ indexPath: IndexPath) -> CNLDataViewerLoadMoreCell {
        return dequeueReusableCell(withReuseIdentifier: "Load More Cell", for: indexPath) as! CNLDataViewerLoadMoreCell // swiftlint:disable:this force_cast
    }
    
    public func batchUpdates(_ updates: @escaping () -> Void) {
        performBatchUpdates(updates, completion: nil)
    }
    
    public func batchUpdates(updates: @escaping () -> Void, completion: @escaping (_ isCompleted: Bool) -> Void) {
        performBatchUpdates(updates, completion: completion)
    }
    
    public func initializeCells() {
        register(loadMoreCellType, forCellWithReuseIdentifier: "Load More Cell")
        //register(CNLCollectionViewLoadMoreCell.self, forCellWithReuseIdentifier: "Load More Cell")
    }
    
    public func selectItemAtIndexPath(_ indexPath: IndexPath, animated: Bool, scrollPosition position: CNLDataViewerScrollPosition) {
        selectItem(at: indexPath, animated: animated, scrollPosition: position.collectionViewScrollPosition)
    }
    
    public func notifyDelegateDidSelectItemAtIndexPath(_ indexPath: IndexPath) {
        delegate?.collectionView!(self, didSelectItemAt: indexPath)
    }
    
    public func selectedItemPaths() -> [IndexPath] {
        return selectedItemPaths()
    }
    
    public func scrollToIndexPath(_ indexPath: IndexPath, atScrollPosition position: CNLDataViewerScrollPosition, animated: Bool) {
        scrollToItem(at: indexPath, at: position.collectionViewScrollPosition, animated: animated)
    }
    
    func nonEmptySections() -> [Int] {
        return (0..<numberOfSections).filter { return self.numberOfItems(inSection: $0) > 0 }
    }
    
    public func scrollToTop(_ animated: Bool = true) {
        let sections = nonEmptySections()
        if let section = sections.first {
            scrollToItem(
                at: IndexPath(item: 0, section: section),
                at: UICollectionViewScrollPosition.top,
                animated: animated
            )
        }
    }
    
    public func scrollToBottom(_ animated: Bool = true) {
        let sections = nonEmptySections()
        if let section = sections.last {
            let rowCount = numberOfItems(inSection: section)
            scrollToItem(
                at: IndexPath(item: rowCount, section: section),
                at: UICollectionViewScrollPosition.top,
                animated: true
            )
        }
    }
    
    public func deselectAll(_ animated: Bool = true) {
        let items = (0..<numberOfSections).flatMap { section in
            return (0..<self.numberOfItems(inSection: section)).map {
                return IndexPath(item: section, section: $0)
            }
        }
        
        for item in items {
            deselectItem(at: item, animated: animated)
        }
    }
    
    public func reloadSections(_ sections: IndexSet, withRowAnimation animation: CNLDataViewerCellAnimation) {
        reloadSections(sections)
    }
    
    public func reloadItemsAtIndexPaths(_ indexes: [IndexPath], withAnimation animation: CNLDataViewerCellAnimation) {
        reloadItems(at: indexes)
    }
    
    public func createIndexPath(item: Int, section: Int) -> IndexPath {
        return IndexPath(item: item, section: section)
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
            let model = dataProvider.dataSource.model
            if  model.isPagingEnabled {
                dataProvider.fetchNext(completed: nil)
            }
            return cell as! UICollectionViewCell // swiftlint:disable:this force_cast
        } else {
            let cell = self[cellIdentifier, indexPath]
            if let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
                cell.setupCell(self, indexPath: indexPath, cellInfo: item, context: context)
            }
            return cell as! UICollectionViewCell // swiftlint:disable:this force_cast
        }
    }
    
    public func cellSizeForItemAtIndexPath<T: CNLDataProvider>(_ dataProvider: T, indexPath: IndexPath, context: CNLModelObject?) -> CGSize? where T.ModelType.ArrayElement: CNLModelObject {
        if dataProvider.dataProviderVariables.isLoadMoreIndexPath(indexPath) {
            return CNLCollectionViewLoadMoreCell.cellSize(self, indexPath: indexPath)
        } else {
            if let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
                return cellType?(indexPath)?.cellSize(self, indexPath: indexPath, cellInfo: item, context: context)
            }
        }
        return CGSize.zero
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
        let indexPath = createIndexPath(item: 0, section: section)
        if let currentHeaderType = headerType?(section), let item = dataProvider.itemAtIndexPath(indexPath: indexPath) {
            return currentHeaderType.headerHeight(self, section: section, cellInfo: item)
        }
        return 0
    }
    
}

open class CNLCollectionViewLoadMoreCell: UICollectionViewCell, CNLDataViewerLoadMoreCell {
    
    open var activity: CNLDataViewerActivity?
    open var createActivity: () -> CNLDataViewerActivity? = { _ in return nil }
    
    open func setupCell<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) where T : UIView {
        contentView.backgroundColor = UIColor.clear
        activity = createActivity()
        if let activity = activity as? UIView {
            contentView.addSubview(activity)
        }
    }
    
    static open func cellSize<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) -> CGSize where T: UIView {
        return CGSize(width: dataViewer.frame.width, height: 40)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        // sometimes layout is called BEFORE setupCell - workaround this bug
        if activity != nil {
            let minimalDimension = min(bounds.width, bounds.height)
            activity!.frame.size = CGSize(width: minimalDimension, height: minimalDimension)
            activity!.frame.origin = CGPoint(x: bounds.midX - minimalDimension / 2.0, y: 0)
            if !activity!.isAnimating {
                activity!.startAnimating()
            }
        }
    }
    
}

/*
class CNLCollectionViewLoadMoreCell: UICollectionViewCell, CNLDataViewerLoadMoreCell {
    
    var activity: NVActivityIndicatorView?
    
    func setupCell<T : CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) where T : UIView {
        activity = NVActivityIndicatorView(
            frame: CGRect.zero,
            type: NVActivityIndicatorType.randomType,
            color: RPUIConfig.config.basicControls.animationColor,
            padding: nil
        )
        contentView.addSubview(activity)
    }
    
    static func cellSize<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) -> CGSize where T: UIView {
        return CGSize(width: dataViewer.frame.width, height: 40)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minimalDimension = min(bounds.width, bounds.height)
        activity.frame.size = CGSize(width: minimalDimension, height: minimalDimension)
        activity.center = CGPoint(x: bounds.midX, y: minimalDimension / 2.0)
        if !activity.isAnimating {
            activity.startAnimating()
        }
    }
    
}
*/
