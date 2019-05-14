//
//  DataResponseDecoder.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Trivial decoder that just returnes data
class DataResponseDecoder: ResponseDecoder<Data> {
    override func decode(from data: Data) throws -> Data {
        return data
    }
}
