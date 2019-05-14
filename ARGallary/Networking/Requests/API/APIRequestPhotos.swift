//
//  APIRequestPhotos.swift
//  ARGallary
//
//  Created by Danila Shikulin on 09/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Photos API request model
class APIRequestPhotos: APIRequest<[Photo]> {
    init(albumId: Int) {
        super.init(path: "/photos",
                   parameters: ["albumId": String(albumId)])
    }
}
