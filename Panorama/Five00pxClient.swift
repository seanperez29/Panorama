//
//  Five00pxClient.swift
//  Panorama
//
//  Created by Sean Perez on 7/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

class Five00pxClient {
    
    func performImageSearch(_ searchTerm: String, _ pageNumber: Int, completionHandler: @escaping (_ results: AnyObject?, _ errorString: String?) -> Void) {
        let methodParameters = [Constants.Five00pxParameterKeys.term: searchTerm, Constants.Five00pxParameterKeys.consumerKey: Constants.Five00pxParameterValues.consumerKey, Constants.Five00pxParameterKeys.page: pageNumber] as [String: AnyObject]
        
        
    }
    
}
