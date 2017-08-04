//
//  CNLDataProviderEditable.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

public protocol CNLDataProviderEditable: CNLDataProvider {
    
    var canEdit: Bool { get set }
    var instructionsLabel: UILabel! { get set }
    var instructionsLabelHeightConstraint: NSLayoutConstraint! { get set }
    var visualEffectView: UIView? { get set }
    var editBarButtonItem: UIBarButtonItem! { get set }
    var editButtonTitle: String { get set }
    var doneButtonTitle: String { get set }
    
    func editAction(_ animated: Bool, willStartEditing: () -> Void, willFinishEditing: () -> Void)
    func saveAction()
}

public extension CNLDataProviderEditable where Self: CNLCanShowViewAcvtitity,
Self.ModelType.ArrayElement: CNLModelDictionaryKeyStored, Self.ModelType: CNLModelObjectEditable {
    
    fileprivate typealias Lists = (old: [ModelType.ArrayElement], new: [ModelType.ArrayElement])
    
    fileprivate func switchEditing() -> Lists {
        var result = Lists(old: self.dataSource.allItems, new: [])
        self.dataSource.model.editing = !self.dataSource.model.editing
        self.dataSource.model.updateList()
        self.dataSource.reset()
        self.dataSource.requestCompleted()
        result.new = self.dataSource.allItems
        return result
    }
    
    fileprivate func startEditing(_ animated: Bool) {
        dataViewer.allowsMultipleSelection = true
        instructionsLabel.frame.size.height = 0.0
        instructionsLabel.isHidden = false
        if let view = dataViewer as? UIView {
            visualEffectView?.frame.size.width = view.frame.width
        }
        visualEffectView?.frame.size.height = 0.0
        visualEffectView?.isHidden = false
        UIView.setAnimationsEnabled(animated)
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.dataViewer.setContentOffset(CGPoint(x: 0.0, y: -64.0), animated: false)
                self.dataViewer.contentInset = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
                self.instructionsLabel.frame.size.height = 64.0
                self.visualEffectView?.frame.size.height = 64.0
                self.editBarButtonItem.title = self.doneButtonTitle
                
                var items: [IndexPath] = []
                self.dataViewer.batchUpdates(
                    updates: {
                        let lists = self.switchEditing()
                        var i = 0
                        var inserted: [Int] = []
                        for (index, item) in lists.new.enumerated() {
                            if (i >= lists.old.count) || (lists.old[i].primaryKey != item.primaryKey) {
                                inserted.append(index)
                            } else {
                                i += 1
                            }
                        }
                        items = inserted.map { return self.dataViewer.createIndexPath(item: $0, section: 0) } // !!! section
                        self.dataViewer.insertItems(at: items)
                        self.updateCounts()
                },
                    completion: { _ in
                        items.forEach {
                            self.dataViewer.selectItemAtIndexPath($0, animated: false, scrollPosition: .none)
                            self.dataViewer.notifyDelegateDidSelectItemAtIndexPath($0)
                        }
                }
                )
        },
            completion: { _ in
                UIView.setAnimationsEnabled(true)
        }
        )
    }
    
    fileprivate func finishEditing(_ animated: Bool) {
        instructionsLabel.frame.size.height = 64.0
        visualEffectView?.frame.size.height = 64.0
        self.dataViewer.setContentOffset(CGPoint(x: 0, y: self.dataViewer.contentOffset.y), animated: true)
        UIView.setAnimationsEnabled(animated)
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.dataViewer.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                self.instructionsLabel.frame.size.height = 0.0
                self.visualEffectView?.frame.size.height = 0.0
                self.editBarButtonItem.title = self.editButtonTitle
                
                self.dataViewer.batchUpdates(
                    updates: {
                        let lists = self.switchEditing()
                        
                        var i = 0
                        var removed: [Int] = []
                        for (index, item) in lists.old.enumerated() {
                            if (i >= lists.new.count) || (lists.new[i].primaryKey != item.primaryKey) {
                                removed.append(index)
                            } else {
                                i += 1
                            }
                        }
                        let items = removed.map { return self.dataViewer.createIndexPath(item: $0, section: 0) } // !!! section
                        self.dataViewer.deleteItems(at: items)
                        self.updateCounts()
                }, completion: { _ in
                    self.dataViewer.allowsMultipleSelection = false
                    self.saveAction()
                }
                )
        },
            completion: { _ in
                self.instructionsLabel.isHidden = true
                self.visualEffectView?.isHidden = true
                UIView.setAnimationsEnabled(true)
        }
        )
    }
    
    func editAction(_ animated: Bool, willStartEditing: () -> Void, willFinishEditing: () -> Void) {
        guard canEdit else { return }
        if !dataSource.model.editing {
            willStartEditing()
            startEditing(animated)
        } else {
            willFinishEditing()
            finishEditing(animated)
        }
    }
    
}
