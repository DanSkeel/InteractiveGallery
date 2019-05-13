//
//  ImageLoading.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

protocol ImageLoading: AnyObject {
    typealias Key = AnyObject
    
    func loadImage(at url: URL, key: Key, completionHandler: @escaping (UIImage?) -> Void)
    
    func cancelLoading(for key: Key)
}
