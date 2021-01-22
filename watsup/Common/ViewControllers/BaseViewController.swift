//
//  BaseViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/22.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - objc method
    @objc func keyboardWillShow(_ sender: NSNotification) {
    }

    @objc func keyboardWillHide(_ sender: NSNotification) {
    }
}
