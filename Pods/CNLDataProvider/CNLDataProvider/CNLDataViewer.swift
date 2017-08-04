//
//  CNLDataViewer.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public typealias CNLDataViewerCellTypeFunc = ((_ indexPath: IndexPath) -> CNLDataViewerCell.Type?)
public typealias CNLDataViewerHeaderTypeFunc = ((_ section: Int) -> CNLDataViewerHeader.Type?)

public enum CNLDataViewerScrollPosition {
    case none, top, centeredVertically, bottom, left, centeredHorizontally, right
    public var tableViewScrollPosition: UITableViewScrollPosition {
        switch self {
        case .none: return .none
        case .top: return .top
        case .centeredVertically: return .middle
        case .bottom: return .bottom
        default: return .none
        }
    }
    public var collectionViewScrollPosition: UICollectionViewScrollPosition {
        switch self {
        case .none: return UICollectionViewScrollPosition()
        case .top: return .top
        case .centeredVertically: return .centeredVertically
        case .bottom: return .bottom
        case .left: return .left
        case .centeredHorizontally: return .centeredHorizontally
        case .right: return .right
        }
    }
}

public enum CNLDataViewerCellAnimation {
    case fade, right, left, top, bottom, none, middle, automatic
    public var tableViewRowAnimation: UITableViewRowAnimation {
        switch self {
        case .fade: return .fade
        case .right: return .right
        case .left: return .left
        case .top: return .top
        case .bottom: return .bottom
        case .none: return .none
        case .middle: return .middle
        case .automatic: return .automatic
        }
    }
}

public protocol CNLDataViewer: class {
    // basic
    var allowsMultipleSelection: Bool { get set }
    var contentInset: UIEdgeInsets { get set }
    var contentOffset: CGPoint { get set }
    var contentSize: CGSize { get set }
    var scrollIndicatorInsets: UIEdgeInsets { get set }
    var ownerViewController: UIViewController? { get }
    
    func setContentOffset(_ offset: CGPoint, animated: Bool)
    func selectItemAtIndexPath(_ indexPath: IndexPath, animated: Bool, scrollPosition position: CNLDataViewerScrollPosition)
    
    func addSubview(_ subview: UIView)
    
    //
    var cellType: CNLDataViewerCellTypeFunc? { get set }
    var headerType: CNLDataViewerHeaderTypeFunc? { get set }
    
    var loadMoreCellType: AnyClass { get }
    
    subscript (indexPath: IndexPath) -> CNLDataViewerCell { get }
    subscript (cellIdentifier: String?, indexPath: IndexPath) -> CNLDataViewerCell { get }
    func initializeCells()
    func loadMoreCell(_ indexPath: IndexPath) -> CNLDataViewerLoadMoreCell
    func reloadData()
    func batchUpdates(_ updates: @escaping () -> Void)
    func batchUpdates(updates: @escaping () -> Void, completion: @escaping (_ isCompleted: Bool) -> Void)
    func insertSections(_ indexes: IndexSet)
    func insertItemsAtIndexPaths(_ indexes: [IndexPath])
    func deleteSections(_ indexes: IndexSet)
    func deleteItemsAtIndexPaths(_ indexes: [IndexPath])
    
    func reloadSections(_ sections: IndexSet, withRowAnimation animation: CNLDataViewerCellAnimation)
    func reloadItemsAtIndexPaths(_ indexes: [IndexPath], withAnimation animation: CNLDataViewerCellAnimation)
    
    func selectedItemPaths() -> [IndexPath]
    func scrollToIndexPath(_ indexPath: IndexPath, atScrollPosition position: CNLDataViewerScrollPosition, animated: Bool)
    func scrollToTop(_ animated: Bool)
    func scrollToBottom(_ animated: Bool)
    func deselectAll(_ animated: Bool)
    
    func createIndexPath(item: Int, section: Int) -> IndexPath
    
    // Cells
    func cellForItemAtIndexPath<T: CNLDataProvider>(
        _ dataProvider: T,
        cellIdentifier: String?,
        indexPath: IndexPath,
        context: CNLModelObject?
        ) -> AnyObject where T.ModelType: CNLDataSourceModel, T.ModelType.ArrayElement: CNLModelObject
    
    // delegate
    func notifyDelegateDidSelectItemAtIndexPath(_ indexPath: IndexPath)
}

fileprivate var cellTypeFunc = "cellTypeFunc"
fileprivate var headerTypeFunc = "headerTypeFunc"

extension CNLDataViewer {
    
    public var cellType: CNLDataViewerCellTypeFunc? {
        get {
            if let value = (objc_getAssociatedObject(self, &cellTypeFunc) as? CNLAssociated<CNLDataViewerCellTypeFunc?>)?.closure {
                return value
            } else {
                return { indexPath in return nil }
            }
        }
        set {
            objc_setAssociatedObject(self, &cellTypeFunc, CNLAssociated<CNLDataViewerCellTypeFunc?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var headerType: CNLDataViewerHeaderTypeFunc? {
        get {
            if let value = (objc_getAssociatedObject(self, &headerTypeFunc) as? CNLAssociated<CNLDataViewerHeaderTypeFunc?>)?.closure {
                return value
            } else {
                return { section in return nil }
            }
        }
        set {
            objc_setAssociatedObject(self, &headerTypeFunc, CNLAssociated<CNLDataViewerHeaderTypeFunc?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
