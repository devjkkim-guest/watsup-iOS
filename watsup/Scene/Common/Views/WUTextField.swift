//
//  WUTextField.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/06/15.
//

import UIKit

protocol WUTextFieldDelegate: AnyObject {
    func wuTextFieldShouldReturn(_ textField: UITextField) -> Bool
}

class WUTextField: UITextField, UITextFieldDelegate {
    weak var wuDelegate: WUTextFieldDelegate?
    let borderWidth: CGFloat = 1
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        setup()
    }
    
    private func setup() {
        self.textColor = .wuColor(name: .ThemeColor)
        self.font = .systemFont(ofSize: 17)
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.wuColor(name: .ThemeColor).cgColor
        textField.layer.borderWidth = borderWidth
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = borderWidth
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return wuDelegate?.wuTextFieldShouldReturn(textField) ?? false
    }
}
