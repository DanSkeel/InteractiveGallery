//
//  PhotoCollectionViewCell.swift
//  ARGallary
//
//  Created by Danila Shikulin on 10/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    func set(image: UIImage, animated: Bool) {
        UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.image = image
        })
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
