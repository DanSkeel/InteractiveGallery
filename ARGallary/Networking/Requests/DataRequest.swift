//
//  DataRequest.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

class DataRequest: NetworkRequestProtocol {
    typealias ResultValue = Data
    
    var baseUrl: URL
    var path: String?
    var parameters: ParametersMap?
    var responseDecoder: ResponseDecoder<Data> = DataResponseDecoder()
    
    init(baseUrl: URL, path: String? = nil, parameters: ParametersMap? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.parameters = parameters
    }
    
    convenience init(url: URL) {
        self.init(baseUrl: url)
    }
}
