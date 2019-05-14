//
//  ViewControllersProviding.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

protocol ViewControllersProviding: AnyObject {
    
    func viewControllerPresentingAlbums() -> UIViewController
    
    func viewControllerPresenting(album: Album) -> UIViewController
    
    func viewControllerPresentingDetail(photos: [Photo], selectedIndex: Int) -> UIViewController
}
