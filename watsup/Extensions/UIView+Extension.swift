//
//  UIView+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

extension UIView {
    func roundedView() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
