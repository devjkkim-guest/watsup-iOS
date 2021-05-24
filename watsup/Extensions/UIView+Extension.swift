//
//  UIView+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

extension UIView {
    func roundedView(radius: CGFloat? = 12) {
        self.layer.cornerRadius = radius ?? 12
        self.clipsToBounds = true
    }
}
