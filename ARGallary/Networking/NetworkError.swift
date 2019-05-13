//
//  Network+Error.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case unauthorized
    case badUrl
    case requestFailed(underlyingError: Error)
    case unsuccessfulStatus(statusCode: Int)
    case deserializationFailed(underlyingError: Error)
    case emptyData
}
