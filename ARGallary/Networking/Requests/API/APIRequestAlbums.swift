//
//  APIRequestAlbums.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Albums API request model
class APIRequestAlbums: APIRequest<[Album]> {
    init(userId: Int) {
        super.init(path: "/albums",
                   parameters: ["userId": String(userId)])        
    }
}
