//
//  Constants.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

class Constants {
    
    struct Five00pxURL {
        static let scheme = "https"
        static let host = "api.500px.com"
        static let path = "/v1/photos/search"
        static let singlePhotoPath = "/v1/photos"
    }
    
    struct Five00pxParameterKeys {
        static let term = "term"
        static let consumerKey = "consumer_key"
        static let page = "page"
    }
    
    struct Five00pxParameterValues {
        static let consumerKey = "L1Yj9o68dZub8KbSSYEdCrQG5G4tapkehKgqYVKt"
    }
    
    struct Identifiers {
        static let PhotoCollectionViewCell = "PhotoCell"
        static let ImageDetailVC = "ImageDetailVC"
        static let ImageSearchVC = "ImageSearchVC"
        static let ImageDetailTableCell = "ImageDetailTableCell"
    }
}
