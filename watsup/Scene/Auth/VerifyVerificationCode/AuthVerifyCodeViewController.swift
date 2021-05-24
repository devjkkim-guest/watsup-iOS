//
//  AuthVerifyCodeViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import UIKit

class AuthVerifyCodeViewController: UIViewController {

    @IBOutlet weak var tfVerifyCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        if let code = tfVerifyCode.text, let intCode = Int(code) {
            let viewModel = AuthContainer.shared.authViewModel
            let request = PutCSForgotPasswordRequest(verificationCode: intCode)
            viewModel.putCSForgotPassword(request) { result in
                switch result {
                case .success(let data):
                    viewModel.getUser(data: data) { result in
                        switch result {
                        case .success:
                            self.goMain()
                        case .failure(let error):
                            self.showAlert(message: error.errorMsg)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
