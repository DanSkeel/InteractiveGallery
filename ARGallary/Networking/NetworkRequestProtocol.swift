//
//  RequestsProtocol.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Protocol that describes model of network request models
protocol NetworkRequestProtocol {
    /// Type of value returned by network request
    associatedtype ResultValue: Decodable
    typealias ParametersMap = [String: String]
    
    /// Scheme and host
    var baseUrl: URL { get }
    
    /// URL path relative to `baseUrl`
    var path: String? { get }
    
    /// Query parameters
    var parameters: ParametersMap? { get }
    
    /// Object that is responsible for deserialization
    var responseDecoder: ResponseDecoder<ResultValue> { get }
}
