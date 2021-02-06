//
//  AuthVerifyCodeViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import UIKit

class AuthVerifyCodeViewController: UIViewController {

    @IBOutlet weak var tfVerifyCode: UITextField!
    let viewModel = AuthVerifyCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        if let code = tfVerifyCode.text, let intCode = Int(code) {
            let request = PutCSForgotPassword(verification_code: intCode)
            API.shared.request(.putCSForgotPassword(request), responseModel: PutCSForgotPasswordResponse.self) { result in
                switch result {
                case .success(let data):
                    self.viewModel.addUser(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
