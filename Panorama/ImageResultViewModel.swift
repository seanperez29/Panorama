//
//  ImageResultViewModel.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

final class ImageResultViewModel {
    
    let imageID: String
    let descriptionText: String?
    let cameraText: String?
    let photographerText: String
    let imageUrl: String
    var largerImageURL: String? = ""
    let nameText: String
    let ratingText: String
    let favoritesText: String
    let viewsText: String
    
    init(imageResult: ImageResult) {
        descriptionText = imageResult.imageDescription ?? "N/A"
        cameraText = imageResult.camera ?? "N/A"
        photographerText = imageResult.userFullName
        nameText = imageResult.name
        ratingText = imageResult.rating != nil ? "\(imageResult.rating!)" : "0"
        favoritesText = imageResult.favoritesCount != nil ? "\(imageResult.favoritesCount!)" : "0"
        viewsText = imageResult.timesViewed != nil ? "\(imageResult.timesViewed!)" : "0"
        imageUrl = imageResult.imageURL
        imageID = "\(imageResult.id!)"
    }
}
