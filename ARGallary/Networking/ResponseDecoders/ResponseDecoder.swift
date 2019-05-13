//
//  ResponseDecoder.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

class ResponseDecoder<T: Decodable> {
    func decode(from data: Data) throws -> T {
        preconditionFailure("Subclass should override")
    }
}
