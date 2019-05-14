//
//  ImageLoading.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

/// Set of methods that image loader should adopt.
protocol ImageLoading: AnyObject {
    typealias Key = AnyObject
    
    /// Loads image.
    ///
    /// - Parameters:
    ///   - url: Url of the image that should loaded.
    ///   - key: Key that you can use later to identify and cancel download.
    ///   - completionHandler:  The completion handler to call when the load request is complete.
    /// Called on main queue.
    func loadImage(at url: URL, key: Key, completionHandler: @escaping (UIImage?) -> Void)
    
    /// Cancels loading of image for key.
    ///
    /// - Parameter key: Key of image, which downloading should be cancled.
    func cancelLoading(for key: Key)
}
