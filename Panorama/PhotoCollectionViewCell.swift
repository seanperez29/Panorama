//
//  PhotoCollectionViewCell.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var dataTask: URLSessionDataTask?
    
    func configureCell(_ imageResult: ImageResult) {
        titleLabel.text = imageResult.name
        dataTask = Five00pxClient.sharedInstance.getImage(imageResult.imageURL) { [weak self] (data, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil else {
                print("Unable to download image")
                return
            }
            if let image = UIImage(data: data!) {
                strongSelf.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        dataTask?.cancel()
        dataTask = nil
        imageView.image = nil
        titleLabel.text = nil
    }
    
}
