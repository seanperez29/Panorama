//
//  FavoritesTableViewCell.swift
//  Panorama
//
//  Created by Sean Perez on 7/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var dataTask: URLSessionDataTask?
    
    func configureCell(_ imageResult: ImageRealmObject) {
        nameLabel.text = imageResult.name
        dataTask = Five00pxClient.sharedInstance.getImage(imageResult.imageURL) { [weak self] (data, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil else {
                print("Unable to download image")
                return
            }
            if let image = UIImage(data: data!) {
                strongSelf.favoritesImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        dataTask?.cancel()
        dataTask = nil
        favoritesImageView.image = nil
        nameLabel.text = nil
    }

}
