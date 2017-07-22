//
//  Five00pxTasks.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

extension Five00pxClient {
    
    func taskForImageItems(_ parameters: [String: AnyObject], _ imageResult: ImageResultViewModel? = nil, completionHandler: @escaping (_ results: [ImageResult]?, _ singleImage: ImageResultViewModel?, _ errorString: String?) -> Void) {
        var request: URLRequest
        if imageResult == nil {
            request = URLRequest(url: five00pxURLFromParameters(parameters))
        } else {
            request = URLRequest(url: five00pxURLFromParameters(parameters, imageResult!.imageID))
        }
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ errorString: String) {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, errorString)
                }
            }
            guard error == nil else {
                sendError("We have experienced an unknown error")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("We have experienced an error")
                return
            }
            guard let data = data else {
                sendError("We could not obtain any images")
                return
            }
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                sendError("We could not obtain any images")
                return
            }
            if imageResult == nil {
                guard let photosArray = parsedResult["photos"] as? [[String: AnyObject]] else {
                    sendError("We could not obtain any images")
                    return
                }
                var resultsArray = [ImageResult]()
                for photo in photosArray {
                    if let imageResult = ImageResult(JSON: photo) {
                        resultsArray.append(imageResult)
                    }
                }
                completionHandler(resultsArray, nil, nil)
            } else {
                guard let photo = parsedResult["photo"] as? [String: AnyObject] else {
                    sendError("We could not obtain the image")
                    return
                }
                guard let images = photo["images"] as? [[String: AnyObject]], let httpsURL = images[0]["https_url"] as? String else {
                    sendError("We could not obtain the image")
                    return
                }
                guard let imageResult = imageResult else { return }
                imageResult.largerImageURL = httpsURL
                completionHandler(nil, imageResult, nil)
            }
        }
        task.resume()
    }
    
    func getImage(_ imageUrl: String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void) -> URLSessionDataTask {
        guard let url = URL(string: imageUrl) else { return URLSessionDataTask() }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(nil, error.localizedDescription)
                } else {
                    completionHandler(data, nil)
                }
            }
        }
        task.resume()
        return task
    }
    
    func five00pxURLFromParameters(_ parameters: [String:AnyObject], _ imageID: String? = "") -> URL {
        var components = URLComponents()
        components.scheme = Constants.Five00pxURL.scheme
        components.host = Constants.Five00pxURL.host
        components.path = imageID == "" ? Constants.Five00pxURL.path : "\(Constants.Five00pxURL.singlePhotoPath)/\(imageID!)"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print("PATH: \(components.url!)")
        return components.url!
    }
}
