//
//  APIProtocol.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Protocol that describes API of the service
protocol APIProtocol {
    
    /// Retrives albums.
    ///
    /// - Parameter completionHandler: The completion handler to call when the load request is complete.
    /// Called on main queue.
    func albums(completionHandler: @escaping (Result<[Album], Error>) -> Void)
    
    /// Retrives photos from the album.
    ///
    /// - Parameters:
    ///   - album: Album which contents will be Retrives.
    ///   - completionHandler: The completion handler to call when the load request is complete.
    /// Called on main queue.
    func photos(in album: Album, completionHandler: @escaping (Result<[Photo], Error>) -> Void)
}
