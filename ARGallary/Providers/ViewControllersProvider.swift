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
    private weak var imageLoader: ImageLoading?
    
    private func getImageLoader() -> ImageLoading {
        if let loader = self.imageLoader {
            return loader
        } else {
            let loader = ImageLoader(networkClient: networkClient)
            self.imageLoader = loader
            return loader
        }
    }

    func viewControllerPresentingAlbums() -> UIViewController {
        return AlbumsViewController(apiClient: networkClient, viewControllersProvider: self)
    }
    
    func viewControllerPresenting(album: Album) -> UIViewController {
        let viewController = PhotosViewController(apiClient: networkClient,
                                                  imageLoader: getImageLoader(),
                                                  viewControllersProvider: self)
        viewController.album = album
        return viewController
    }
    
    func viewControllerPresentingDetail(photos: [Photo], selectedIndex: Int) -> UIViewController {
        return DetailPhotosViewController(photos: photos,
                                          selectedIndex: selectedIndex,
                                          imageLoader: getImageLoader())
    }
}
