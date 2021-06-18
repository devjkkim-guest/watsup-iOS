//
//  XibView.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/22.
//

import UIKit

class XibView: UIView {
    func instanceFrom(object: NSObject) -> UIView? {
        let nibName = String(describing: type(of: object))
        let bundle = Bundle(for: type(of: self))
        return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: object, options: nil).first as? UIView
    }
}
