//
//  APIProtocol.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

protocol APIProtocol {
    
    func albums(completionHandler: @escaping (Result<[Album], Error>) -> Void)
    
    func photos(in album: Album, completionHandler: @escaping (Result<[Photo], Error>) -> Void)
}
