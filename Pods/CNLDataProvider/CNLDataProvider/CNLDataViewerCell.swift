//
//  CNLDataViewerCell.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public protocol CNLDataViewerCell {
    
    static var cellIdentifier: String { get }
    func setupCell<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath, cellInfo: CNLModelObject, context: CNLModelObject?) where T: UIView
    static func cellSize<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath, cellInfo: CNLModelObject, context: CNLModelObject?) -> CGSize where T: UIView
    
}

public protocol CNLDataViewerLoadMoreCell {
    var activity: CNLDataViewerActivity? { get set }

    var createActivity: () -> CNLDataViewerActivity? { get set }
    
    func setupCell<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) where T: UIView
    static func cellSize<T: CNLDataViewer>(_ dataViewer: T, indexPath: IndexPath) -> CGSize where T: UIView
}

public protocol CNLDataViewerHeader {
    
    static func setupHeader(_ dataViewer: CNLDataViewer, view: UIView?, section: Int, cellInfo: CNLModelObject?, headerText: String?)
    static func headerHeight(_ dataViewer: CNLDataViewer, section: Int, cellInfo: CNLModelObject?) -> CGFloat
    
}
