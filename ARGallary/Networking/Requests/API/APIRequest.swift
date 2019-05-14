//
//  APIRequest.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Abstract class for API request models.
class APIRequest<T: Decodable>: NetworkRequestProtocol {
    typealias ResultValue = T
    
    let baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    let path: String?
    let parameters: ParametersMap?
    let responseDecoder: ResponseDecoder<T> = JSONResponseDecoder<T>()
    
    init(path: String, parameters: ParametersMap) {
        self.path = path
        self.parameters = parameters
    }
}
