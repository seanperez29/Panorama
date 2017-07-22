//
//  ImageResult.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageResult: Mappable {
    
    var id: Int!
    var name: String!
    var imageDescription: String!
    var camera: String!
    var rating: Int!
    var timesViewed: Int!
    var imageURL: String!
    var largerImageURL: String!
    var userFullName: String!
    var favoritesCount: Int!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageDescription <- map["description"]
        camera <- map["camera"]
        rating <- map["rating"]
        timesViewed <- map["times_viewed"]
        imageURL <- map["image_url"]
        userFullName <- map["user.fullname"]
        favoritesCount <- map["favorites_count"]
    }
}
