//
//  ViewControllersProviding.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

/// Protocol for entity that provides view controllers.
protocol ViewControllersProviding: AnyObject {
    
    /// Returns view controller that presents albums.
    ///
    /// - Returns: View controller.
    func viewControllerPresentingAlbums() -> UIViewController
    
    /// Returns view controller that presents given album.
    ///
    /// - Parameter album: Album to present.
    /// - Returns: View controller.
    func viewControllerPresenting(album: Album) -> UIViewController
    
    /// Returns view controller that shows detailed photos.
    ///
    /// - Parameters:
    ///   - photos: Photos to show.
    ///   - selectedIndex: Index of photo that should be shown.
    /// - Returns: View controller.
    func viewControllerPresentingDetail(photos: [Photo], selectedIndex: Int) -> UIViewController
}
