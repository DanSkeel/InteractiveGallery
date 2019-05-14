//
//  DetailPhotosViewController.swift
//  ARGallary
//
//  Created by Danila Shikulin on 14/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

/// View controller that shows detail photo from a collection of photos. Has a potential for pagination.
class DetailPhotosViewController: UIViewController {
    
    private let photos: [Photo]
    private var selectedIndex: Int
    private let imageLoader: ImageLoading
    
    private let detailPhotoView: DetailPhotoView = .fromNib()
    
    init(photos: [Photo], selectedIndex: Int, imageLoader: ImageLoading) {
        precondition(photos.indices.contains(selectedIndex))
        
        self.photos = photos
        self.selectedIndex = selectedIndex
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let photo = photos[selectedIndex]
        detailPhotoView.title = photo.title
        
        self.detailPhotoView.image = nil
        imageLoader.loadImage(at: photo.thumbnailUrl, key: view) { [weak self] image in
            guard let detailPhotoView = self?.detailPhotoView else {
                return
            }
            if detailPhotoView.image == nil {
                detailPhotoView.image = image
            }
        }
        imageLoader.loadImage(at: photo.url, key: view) { [weak self] image in
            self?.detailPhotoView.image = image
        }
    }
}
