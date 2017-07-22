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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var imageResults = [ImageResult]()
    var currentPage = 1
    var currentSearchTerm = ""
    var hasReloaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setTheActivityIndicator(false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let cellNib = UINib(nibName: "ActivityCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "ActivityCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.ImageDetailVC {
            let navigationController = segue.destination as! UINavigationController
            let imageDetailVC = navigationController.viewControllers[0] as! ImageDetailVC
            let imageResult = sender as! ImageResult
            let imageViewModel = ImageResultViewModel(imageResult: imageResult)
            imageDetailVC.imageViewModel = imageViewModel
            imageDetailVC.imageResult = imageResult
        }
    }
    
    func setTheActivityIndicator(_ bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = !bool
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = !bool
        }
    }
    
}

extension ImageSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResults.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == imageResults.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            if hasReloaded {
                cell.activityIndicator.startAnimating()
                cell.activityIndicator.isHidden = false
            } else {
                cell.activityIndicator.isHidden = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.PhotoCollectionViewCell, for: indexPath) as! PhotoCollectionViewCell
            let imageResult = imageResults[indexPath.row]
            cell.configureCell(imageResult)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageResult = imageResults[indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.ImageDetailVC, sender: imageResult)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= scrollView.contentSize.height) {
            currentPage += 1
            Five00pxClient.sharedInstance.performImageSearch(currentSearchTerm, currentPage) { [weak self] (results, errorString) in
                guard let strongSelf = self else { return }
                guard errorString == nil else {
                    strongSelf.showAlert(errorString!)
                    return
                }
                let resultCount = strongSelf.imageResults.count
                let (start, end) = (resultCount, results!.count + resultCount)
                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                strongSelf.imageResults.append(contentsOf: results!)
                strongSelf.collectionView.performBatchUpdates({
                    strongSelf.collectionView.insertItems(at: indexPaths)
                }, completion: nil)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
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
        setTheActivityIndicator(true)
        currentSearchTerm = searchTerm
        Five00pxClient.sharedInstance.performImageSearch(searchTerm, 1) { [weak self] (results, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil, results != nil else {
                strongSelf.showAlert(errorString!)
                return
            }
            if results!.isEmpty {
                strongSelf.hasReloaded = false
                strongSelf.setTheActivityIndicator(false)
                strongSelf.showAlert("No search results found")
            } else {
                strongSelf.imageResults = results!
                strongSelf.hasReloaded = true
                strongSelf.setTheActivityIndicator(false)
                strongSelf.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

}
