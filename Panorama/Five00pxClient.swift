//
//  Five00pxClient.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class Five00pxClient {
    
    static let sharedInstance = Five00pxClient()
    let session = URLSession.shared
    
    func performImageSearch(_ searchTerm: String, _ pageNumber: Int, completionHandler: @escaping (_ results: [ImageResult]?, _ errorString: String?) -> Void) {
        let methodParameters = [Constants.Five00pxParameterKeys.term: searchTerm, Constants.Five00pxParameterKeys.consumerKey: Constants.Five00pxParameterValues.consumerKey, Constants.Five00pxParameterKeys.page: pageNumber] as [String: AnyObject]
        
        taskForImageItems(methodParameters) { (results, _, errorString) in
            guard errorString == nil else {
                completionHandler(nil, errorString)
                return
            }
            DispatchQueue.main.async {
                completionHandler(results, nil)
            }
        }
    }
    
    func retrieveIndividualPhoto(_ imageResult: ImageResultViewModel, completionHandler: @escaping (_ result: UIImage?, _ errorString: String?) -> Void) {
        let methodParameters = [Constants.Five00pxParameterKeys.consumerKey: Constants.Five00pxParameterValues.consumerKey] as [String: AnyObject]
        
        taskForImageItems(methodParameters, imageResult) { [weak self] (_, result, errorString) in
            guard let strongSelf = self else { return }
            guard errorString == nil else {
                completionHandler(nil, errorString)
                return
            }
            _ = strongSelf.getImage(result!.largerImageURL!) { (data, errorString) in
                guard errorString == nil else {
                    completionHandler(nil, errorString)
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        completionHandler(image, nil)
                    }
                }
            }
        }
    }
    
}
