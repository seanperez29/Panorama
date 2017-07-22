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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.ImageDetailVC {
            let imageDetailVC = storyboard!.instantiateViewController(withIdentifier: Constants.Identifiers.ImageDetailVC) as! ImageDetailVC
            let imageResult = sender as! ImageResult
            imageDetailVC.imageResult = imageResult
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
    
}

extension ImageSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Five00pxClient.sharedInstance.performImageSearch(searchBar.text!, 1) { [weak self] (results, errorString) in
            guard errorString == nil, results != nil else {
                print(errorString)
                return
            }
            if let strongSelf = self {
                strongSelf.imageResults = results!
                strongSelf.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

}
