//
//  AuthJoinViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit
import RxSwift
import RxCocoa

class AuthJoinViewController: BaseAuthViewController {

    @IBOutlet weak var tfEmail: WUTextField!
    @IBOutlet weak var tfPassword: WUTextField!
    @IBOutlet weak var tfConfirmPassword: WUTextField!
    @IBOutlet weak var guideLabel: UILabel!
    let viewModel: AuthViewModel = Container.shared.resolve(id: authViewModelId)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.wuDelegate = self
        tfPassword.wuDelegate = self
        tfConfirmPassword.wuDelegate = self
        
        bottomButton.button.isEnabled = false
        bottomButton.button.setTitle("Button.Join".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickJoin(_:)), for: .touchUpInside)
        
        tfEmail.rx.text
            .subscribe(onNext: { text in
                guard let email = text, !email.isEmpty else {
                    self.viewModel.isValidEmail.onNext(.empty)
                    return
                }
                if email.isValidEmail() == true {
                    self.viewModel.isValidEmail.onNext(.valid)
                } else {
                    self.viewModel.isValidEmail.onNext(.notValid)
                }
            }).disposed(by: disposeBag)

        Observable.combineLatest(tfPassword.rx.text, tfConfirmPassword.rx.text)
            .subscribe(onNext: { text1, text2 in
                guard let password1 = text1, !password1.isEmpty else { self.viewModel.isEqualPassword.onNext(.empty)
                    return
                }
                guard let password2 = text2, !password2.isEmpty else {
                    self.viewModel.isEqualPassword.onNext(.empty)
                    return
                }
                if password1 == password2 {
                    self.viewModel.isEqualPassword.onNext(.match)
                } else {
                    self.viewModel.isEqualPassword.onNext(.notMatch)
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.isValidEmail, viewModel.isEqualPassword)
            .subscribe(onNext: { isValidEmail, isEqualPassword in
                if isValidEmail == .empty {
                    self.bottomButton.button.isEnabled = false
                    self.guideLabel.text = "Fill Email."
                } else if isValidEmail == .notValid {
                    self.bottomButton.button.isEnabled = false
                    self.guideLabel.text = "Check Email Address"
                } else if isEqualPassword == .empty {
                    self.bottomButton.button.isEnabled = false
                    self.guideLabel.text = "Fill Password."
                } else if isEqualPassword == .notMatch {
                    self.bottomButton.button.isEnabled = false
                    self.guideLabel.text = "Password is not identical."
                } else {
                    self.bottomButton.button.isEnabled = true
                    self.guideLabel.text?.removeAll()
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func onClickJoin(_ sender: UIButton) {
        guard let email = tfEmail.text else { return }
        guard let password = tfPassword.text else { return }
        
        WUProgress.show()
        viewModel.postUser(email: email, password: password) { result in
            WUProgress.dismiss()
            switch result {
            case .success:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
                } else {
                    self.showAlert(message: "failed \(#function) \(#line)")
                }
            case .failure(let error):
                self.showAlert(message: error.localizedErrorMessage)
            }
        }
    }
}

extension AuthJoinViewController: WUTextFieldDelegate {
    func wuTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail {
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfConfirmPassword.becomeFirstResponder()
        } else if textField == tfConfirmPassword {
            textField.endEditing(true)
        }
        return true
    }
}
