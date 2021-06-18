//
//  AuthVerifyCodeViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import UIKit
import RxSwift

class AuthVerifyCodeViewController: BaseAuthViewController {
    @IBOutlet weak var tfVerifyCode: WUTextField!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfVerifyCode.becomeFirstResponder()
        
        bottomButton.button.isEnabled = false
        bottomButton.button.setTitle("Button.Login".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickLogin(_:)), for: .touchUpInside)
        
        tfVerifyCode.wuDelegate = self
        tfVerifyCode.rx.text.subscribe(onNext: { text in
            if text?.isEmpty == false {
                self.bottomButton.button.isEnabled = true
            } else {
                self.bottomButton.button.isEnabled = false
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func onClickLogin(_ sender: UIButton) {
        if let code = tfVerifyCode.text {
            let viewModel: AuthViewModel = Container.shared.resolve(id: authViewModelId)
            let request = PutCSForgotPasswordRequest(verificationCode: code)
            viewModel.putCSForgotPassword(request) { result in
                switch result {
                case .success(let data):
                    viewModel.getUser(data: data) { result in
                        switch result {
                        case .success:
                            self.goMain()
                        case .failure(let error):
                            self.showAlert(message: error.localizedErrorMessage)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension AuthVerifyCodeViewController: WUTextFieldDelegate {
    func wuTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfVerifyCode {
            textField.endEditing(true)
        }
        return true
    }
}
