//
//  AuthLoginViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit
import Alamofire

class AuthLoginViewController: BaseAuthViewController {

    @IBOutlet weak var tfEmail: WUTextField!
    @IBOutlet weak var tfPassword: WUTextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    let viewModel: AuthViewModel = Container.shared.resolve(id: authViewModelId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.becomeFirstResponder()
        tfEmail.placeholder = "Email"
        tfEmail.wuDelegate = self
        
        tfPassword.placeholder = "Password"
        tfPassword.wuDelegate = self
        
        bottomButton.button.setTitle("Button.Login".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickLogin(_:)), for: .touchUpInside)
    }
    
    @objc func onClickLogin(_ sender: UIButton) {
        guard let email = tfEmail.text, !email.isEmpty else {
            showAlert(message: "Fill email.")
            return
        }
        guard let password = tfPassword.text, !password.isEmpty else {
            showAlert(message: "Fill password.")
            return
        }
        let request = PostAuthRequest(email: email, password: password)
        WUProgress.show()
        viewModel.postAuth(request) { result in
            WUProgress.dismiss()
            switch result {
            case .success:
                self.goMain()
            case .failure(let error):
                self.showAlert(message: error.localizedErrorMessage)
            }
        }
    }
}

extension AuthLoginViewController: WUTextFieldDelegate {
    func wuTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
