//
//  Five00pxTasks.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

extension Five00pxClient {
    
    func taskForImageItems(_ parameters: [String: AnyObject], completionHandler: @escaping (_ results: AnyObject?, _ errorString: String?) -> Void) {
        let session = URLSession.shared
        var request = URLRequest(url: five00pxURLFromParameters(parameters))
        request.httpMethod = "GET"
        
    }
    
    func five00pxURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Five00pxURL.scheme
        components.host = Constants.Five00pxURL.host
        components.path = Constants.Five00pxURL.path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
