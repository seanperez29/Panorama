//
//  ViewController.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class ImageSearchVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarContainer: UIView!
    var searchController: UISearchController!
    var imageResults: [ImageResult]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchBarContainer.addSubview(searchController.searchBar)
        automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

}

extension ImageSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
}

extension ImageSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Five00pxClient.sharedInstance.performImageSearch(searchBar.text!, 1) { [weak self] (results, errorString) in
            guard errorString == nil else {
                print(errorString)
                return
            }
            if let strongSelf = self {
                strongSelf.imageResults = results
                strongSelf.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
}
