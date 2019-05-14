//
//  Network+Error.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Error that can be thrown by network client.
enum NetworkError: Error {
    // Uknown error.
    case unknown
    
    // UserId is missing
    case unauthorized
    
    // Failed to compose valid url for request
    case badUrl
    
    // Request failed with some error from `NSURLErrorDomain` domain
    case requestFailed(underlyingError: Error)
    
    // Client recevied status other than 200
    case unsuccessfulStatus(statusCode: Int)

    // No data recevied
    case emptyData

    // Failed to deserialize recevied data
    case deserializationFailed(underlyingError: Error)
}
