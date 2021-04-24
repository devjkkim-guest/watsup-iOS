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
    
    func addExternalBorder(borderWidth: CGFloat = 2, borderColor: UIColor = .white, radius: CGFloat) {
        if let superview = superview {
            let borderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: frame.size.width+borderWidth, height: frame.size.height+borderWidth)))
            borderView.center = center
            borderView.clipsToBounds = clipsToBounds
            borderView.layer.cornerRadius = radius
            borderView.backgroundColor = borderColor 
            superview.insertSubview(borderView, belowSubview: self)
        }
    }
}
