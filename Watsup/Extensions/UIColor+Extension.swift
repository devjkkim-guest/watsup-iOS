//
//  UIColor+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/06/15.
//

import UIKit

enum AssetsColor: String {
    case themeColor
    case wuBlack
    case wuWhite
}

extension UIColor {
    static let themeColor = UIColor.wuColor(name: .themeColor)
    static let wuBlack = UIColor.wuColor(name: .wuBlack)
    static let wuWhite = UIColor.wuColor(name: .wuWhite)
    
    static private func wuColor(name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .black
    }
}
