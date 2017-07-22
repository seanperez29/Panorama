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
    @IBOutlet weak var searchBar: UISearchBar!
    var imageResults = [ImageResult]()
    var currentPage = 1
    var currentSearchTerm = ""
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.ImageDetailVC {
            let navigationController = segue.destination as! UINavigationController
            let imageDetailVC = navigationController.viewControllers[0] as! ImageDetailVC
            let imageResult = sender as! ImageResult
            let imageViewModel = ImageResultViewModel(imageResult: imageResult)
            imageDetailVC.imageViewModel = imageViewModel
        }
    }
    
}

extension ImageSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResults.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.PhotoCollectionViewCell, for: indexPath) as! PhotoCollectionViewCell
        let imageResult = imageResults[indexPath.row]
        cell.configureCell(imageResult)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageResult = imageResults[indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.ImageDetailVC, sender: imageResult)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imageResults.count - 1 {
            currentPage += 1
            Five00pxClient.sharedInstance.performImageSearch(currentSearchTerm, currentPage) { [weak self] (results, errorString) in
                guard let strongSelf = self else { return }
                guard errorString == nil else {
                    print(errorString)
                    return
                }
            }
        }
    }
}

extension ImageSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.width/3)
    }
}

extension ImageSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        currentSearchTerm = searchTerm
        Five00pxClient.sharedInstance.performImageSearch(searchTerm, 1) { [weak self] (results, errorString) in
            guard errorString == nil, results != nil else {
                print(errorString)
                return
            }
            if let strongSelf = self {
                strongSelf.imageResults = results!
                strongSelf.currentIndex = strongSelf.imageResults.count - 1
                strongSelf.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

}
