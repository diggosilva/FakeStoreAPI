//
//  UIView+Extensions.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 25/01/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
