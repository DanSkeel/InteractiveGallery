//
//  ViewControllersProvider.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

class ViewControllersProvider: ViewControllersProviding {
    
    private var networkClient = NetworkClient(userId: 1)

    func viewControllerPresentingAlbums() -> UIViewController {
        return AlbumsViewController(apiClient: networkClient, viewControllersProvider: self)
    }
    
    func viewControllerPresenting(album: Album) -> UIViewController {
        let imageLoader = ImageLoader(networkClient: networkClient)
        let viewController = PhotosViewController(apiClient: networkClient, imageLoader: imageLoader)
        viewController.album = album
        return viewController
    }
}
