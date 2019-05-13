//
//  RequestsProtocol.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

protocol NetworkRequestProtocol {
    associatedtype ResultValue: Decodable
    typealias ParametersMap = [String: String]
    
    var baseUrl: URL { get }
    var path: String? { get }
    var parameters: ParametersMap? { get }
    var responseDecoder: ResponseDecoder<ResultValue> { get }
}
