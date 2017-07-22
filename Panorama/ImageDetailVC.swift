//
//  ImageDetailVC.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import RealmSwift

class ImageDetailVC: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var imageViewModel: ImageResultViewModel!
    var imageResult: ImageResult!
    var imageResultsArray: Results<ImageRealmObject>!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoritesAndSetFavoritesButton()
        setUIForImageResult()
        Five00pxClient.sharedInstance.retrieveIndividualPhoto(imageViewModel) { [weak self] (image, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil else {
                strongSelf.showAlert(errorString!)
                return
            }
            strongSelf.imageView.image = image
        }
    }
    
    func setUIForImageResult() {
        nameLabel.text = imageViewModel.nameText
        photographerLabel.text = imageViewModel.photographerText
        cameraLabel.text = imageViewModel.cameraText
        descriptionLabel.text = imageViewModel.descriptionText
        ratingLabel.text = imageViewModel.ratingText
        viewsLabel.text = imageViewModel.viewsText
        favoritesLabel.text = imageViewModel.favoritesText
    }
    
    func loadFavoritesAndSetFavoritesButton() {
        do {
            let realm = try Realm()
            imageResultsArray = realm.objects(ImageRealmObject.self)
            for image in imageResultsArray {
                if String(image.itemId) == imageViewModel.imageID {
                    favoriteButton.isEnabled = false
                }
            }
        } catch {
            showAlert("We experienced a problem loading this image")
        }
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        do {
            let realm = try Realm()
            let imageRealmObject = ImageRealmObject(itemId: Int(imageViewModel.imageID)!, name: imageViewModel.nameText, imageDescription: imageViewModel.descriptionText!, camera: imageViewModel.cameraText!, rating: Int(imageViewModel.ratingText)!, timesViewed: Int(imageViewModel.viewsText)!, imageURL: imageViewModel.imageUrl, userFullName: imageViewModel.photographerText, favoritesCount: Int(imageViewModel.favoritesText)!)
            try! realm.write {
                realm.add(imageRealmObject)
            }
            favoriteButton.isEnabled = false
        } catch {
            showAlert("We experienced a problem saving your image")
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension ImageDetailVC {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.bounds.size.width / 1.5
        } else {
            return 72
        }
    }
}
