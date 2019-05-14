//
//  File.swift
//  ARGallary
//
//  Created by Danila Shikulin on 10/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

extension Collection {
    /// Save subscript that doesn't crash the app in case of out of bound index.
    ///
    /// - Parameter index: Index of element that we want to get from collecion.
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            assertionFailure("index \(index) is out of bounds in \(self)")
            return nil
        }
    }
}
