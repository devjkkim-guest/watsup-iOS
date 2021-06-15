//
//  UIColor+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/06/15.
//

import UIKit

enum AssetsColor: String {
    case ThemeColor
}

extension UIColor {
    static func wuColor(name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .black
    }
}
