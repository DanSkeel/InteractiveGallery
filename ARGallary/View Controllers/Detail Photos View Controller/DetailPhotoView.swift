//
//  DetailPhotoView.swift
//  ARGallary
//
//  Created by Danila Shikulin on 14/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

/// View that shows detailed photo with title
class DetailPhotoView: UIView {
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            if let constraint = ratioConstraint {
                constraint.isActive = false
            }
            if let image = newValue {
                let ratio = image.size.width/image.size.height
                let constraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: ratio)
                constraint.isActive = true
                ratioConstraint = constraint
            }
            imageView.image = newValue
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    private weak var ratioConstraint: NSLayoutConstraint?
    
    // Use from `fromNib()`
    private init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
}
