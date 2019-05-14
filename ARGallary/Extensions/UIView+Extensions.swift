//
//  UIView+Extensions.swift
//  ARGallary
//
//  Created by Danila Shikulin on 14/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

extension UIView {
    /// Loads `view` of type `T` from xib.
    ///
    /// - Returns: View.
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
