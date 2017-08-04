//
//  CNLSearchController.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 01/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public protocol CNLSearchControllerDelegate: class {
    func searchControllerNeedRefresh(_ controller: CNLSearchController)
    func searchControllerCancelled(_ controller: CNLSearchController)
}

open class CNLSearchController: NSObject, UISearchBarDelegate {
    
    weak var delegate: CNLSearchControllerDelegate?
    
    open var searchQueryText: String?
    
    open var searchBar = UISearchBar()
    open var searchBarButtonItem: UIBarButtonItem!
    open var searchButton: UIButton!
    open var navigationItem: UINavigationItem!
    
    open var isActive = false
    
    open func setupWithDelegate(_ delegate: CNLSearchControllerDelegate, navigationItem: UINavigationItem, buttonImage: UIImage?, searchQueryText: String? = nil) {
        self.delegate = delegate
        searchButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        searchButton.setImage(buttonImage, for: UIControlState())
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        searchButton.addTarget(self, action: #selector(searchButtonAction(_:)), for: .touchUpInside)
        searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem = navigationItem
        
        self.searchQueryText = searchQueryText
        searchBar.text = searchQueryText ?? ""
        searchBar.delegate = self
        searchBar.setShowsCancelButton(true, animated: false)
        updateState()
    }
    
    open func updateState() {
        if isActive {
            // remove the search button
            navigationItem.rightBarButtonItem = nil
            // add the search bar
            navigationItem.titleView = searchBar
            searchBar.becomeFirstResponder()
        } else {
            searchBar.resignFirstResponder()
            navigationItem.rightBarButtonItem = searchBarButtonItem
            navigationItem.titleView = nil
        }
    }
    
    open func activate(animated: Bool) {
        
        isActive = true
        updateState()
        
        if animated {
            searchBar.alpha = 0.0
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.searchBar.alpha = 1.0
                },
                completion: { _ in
                    self.searchBar.becomeFirstResponder()
                }
            )
        } else {
            searchBar.alpha = 1.0
            searchBar.becomeFirstResponder()
        }
    }
    
    open func deactivate(animated: Bool) {
        searchBar.resignFirstResponder()
        hideSearchBar(animated)
        isActive = false
    }
    
    open func hideSearchBar(_ animated: Bool) {
        searchBar.resignFirstResponder()
        //searchBar.setShowsCancelButton(false, animated: true)
        delegate?.searchControllerCancelled(self)
        
        if animated {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.searchBar.alpha = 0.0
                },
                completion: { _ in
                    self.navigationItem.titleView = nil
                    self.navigationItem.rightBarButtonItem = self.searchBarButtonItem
                    self.searchButton.alpha = 0.0  // set this *after* adding it back
                    UIView.animate(
                        withDuration: 0.5,
                        animations: {
                            self.searchButton.alpha = 1.0
                        }
                    )
                }
            )
        } else {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = self.searchBarButtonItem
            searchButton.alpha = 1.0
        }
    }
    
    @objc open func searchButtonAction(_ sender: AnyObject) {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.searchButton.alpha = 0.0
            },
            completion: { _ in
                self.activate(animated: true)
            }
        )
    }
    
    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQueryText = searchBar.text
        delegate?.searchControllerNeedRefresh(self)
        //searchBar.setShowsCancelButton(false, animated: true)
    }
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.setShowsCancelButton(true, animated: true)
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        if (searchQueryText ?? "") != "" {
            searchBarSearchButtonClicked(searchBar)
        }
        deactivate(animated: true)
    }
    
}
