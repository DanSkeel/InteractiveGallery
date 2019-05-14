//
//  ResponseDecoder.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// JSON decoder wrapper
class JSONResponseDecoder<T: Decodable>: ResponseDecoder<T> {
    override func decode(from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
