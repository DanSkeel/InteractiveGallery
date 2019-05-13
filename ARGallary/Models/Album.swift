//
//  Album.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let userId: Int
    let id: Int
    let title: String
}
