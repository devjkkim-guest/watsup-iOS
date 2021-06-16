//
//  AuthRequestCodeViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/01.
//

import UIKit
import Alamofire

class AuthRequestCodeViewController: BaseAuthViewController {
    @IBOutlet weak var tfEmail: WUTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomButton.button.setTitle("Button.Send".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickSendCode(_:)), for: .touchUpInside)
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
        if let email = tfEmail.text {
            let request = PostCSForgotPasswordRequest(email: email)
            API.shared.postCSForgotPassword(request) { result in
                switch result {
                case .success:
                    self.performSegue(withIdentifier: "showAuthVerifyCode", sender: nil)
                case .failure(let error):
                    self.showAlert(message: error.localizedErrorMessage)
                }
            }
        }
    }
}
