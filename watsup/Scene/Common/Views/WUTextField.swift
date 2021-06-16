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
    let normalColor: CGColor = UIColor.systemGray5.cgColor
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        setup()
    }
    
    private func setup() {
        self.textColor = .themeColor
        self.font = .systemFont(ofSize: 17)
        self.layer.borderColor = normalColor
        self.layer.borderWidth = borderWidth
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.themeColor.cgColor
        textField.layer.borderWidth = borderWidth
        textField.textColor = .themeColor
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = normalColor
        textField.layer.borderWidth = borderWidth
        textField.textColor = .gray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return wuDelegate?.wuTextFieldShouldReturn(textField) ?? false
    }
}
