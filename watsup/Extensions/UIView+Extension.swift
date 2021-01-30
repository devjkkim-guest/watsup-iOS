//
//  UIView+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

extension UIView {
    func roundedView(_ value: CGFloat? = 12) {
        self.layer.cornerRadius = value ?? 12
        self.clipsToBounds = true
    }
}
