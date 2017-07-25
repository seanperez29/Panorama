//
//  ImageRealmObject.swift
//  Panorama
//
//  Created by Sean Perez on 7/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import RealmSwift
// ImageRealmObject added for persistence and only created due to ImageResult's conflict conforming to both ObjectMapper as well as RealmSwfit at the same time. This would ideally be solved by doing own parsing of ImageResult's properties and not using ObjectMapper or creating this separate ImageRealmObject. But for brevity sake this was my temporary solution, and would not be the solution of choice on a distributed app.

class ImageRealmObject: Object {
    
    dynamic var itemId = 0
    dynamic var name: String!
    dynamic var imageDescription: String!
    dynamic var camera: String!
    dynamic var rating = 0
    dynamic var timesViewed = 0
    dynamic var imageURL: String!
    dynamic var userFullName: String!
    dynamic var favoritesCount = 0
    
    override class func primaryKey() -> String {
        return "itemId"
    }
    
    convenience init(itemId: Int, name: String, imageDescription: String, camera: String, rating: Int, timesViewed: Int, imageURL: String, userFullName: String, favoritesCount: Int) {
        self.init()
        self.itemId = itemId
        self.name = name
        self.imageDescription = imageDescription
        self.camera = camera
        self.rating = rating
        self.timesViewed = timesViewed
        self.imageURL = imageURL
        self.userFullName = userFullName
        self.favoritesCount = favoritesCount
    }

}
