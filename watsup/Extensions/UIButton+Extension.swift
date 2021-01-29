//
//  UIButton+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

extension UIButton {
    func roundedButton() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
