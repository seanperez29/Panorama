//
//  ImageDetailVC.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class ImageDetailVC: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    var imageViewModel: ImageResultViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = imageViewModel.nameText
        photographerLabel.text = imageViewModel.photographerText
        cameraLabel.text = imageViewModel.cameraText
        descriptionLabel.text = imageViewModel.descriptionText
        ratingLabel.text = imageViewModel.ratingText
        viewsLabel.text = imageViewModel.viewsText
        favoritesLabel.text = imageViewModel.favoritesText
        Five00pxClient.sharedInstance.retrieveIndividualPhoto(imageViewModel) { [weak self] (image, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil else {
                print(errorString)
                return
            }
            strongSelf.imageView.image = image
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
