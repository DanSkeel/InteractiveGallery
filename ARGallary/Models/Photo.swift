//
//  Photo.swift
//  ARGallary
//
//  Created by Danila Shikulin on 09/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
