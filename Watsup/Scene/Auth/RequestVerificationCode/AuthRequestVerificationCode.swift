//
//  AuthRequestCodeViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/01.
//

import UIKit
import Alamofire
import RxSwift

class AuthRequestCodeViewController: BaseAuthViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var tfEmail: WUTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfEmail.wuDelegate = self
        tfEmail.becomeFirstResponder()
        
        bottomButton.button.isEnabled = false
        bottomButton.button.setTitle("Button.Send".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickSendCode(_:)), for: .touchUpInside)
        
        tfEmail.rx.text.subscribe(onNext: { text in
            if text?.isValidEmail() == true {
                self.bottomButton.button.isEnabled = true
            } else {
                self.bottomButton.button.isEnabled = false
            }
        }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func onClickSendCode(_ sender: UIButton) {
        guard let email = tfEmail.text, !email.isEmpty else {
            showAlert(message: "Fill Email.")
            return
        }
        WUProgress.show()
        let request = PostCSForgotPasswordRequest(email: email)
        API.shared.postCSForgotPassword(request) { result in
            WUProgress.dismiss()
            switch result {
            case .success:
                self.performSegue(withIdentifier: "showAuthVerifyCode", sender: nil)
            case .failure(let error):
                self.showAlert(message: error.localizedErrorMessage)
            }
        }
    }
}

extension AuthRequestCodeViewController: WUTextFieldDelegate {
    func wuTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
