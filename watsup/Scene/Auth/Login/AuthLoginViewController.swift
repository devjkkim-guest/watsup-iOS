//
//  AuthLoginViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit
import Alamofire

class AuthLoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    let viewModel = AuthLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingWhenTapBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        guard let email = tfEmail.text else {
            return
        }
        guard let password = tfPassword.text else {
            return
        }
        let request = PostAuthRequest(email: email, password: password)
        viewModel.postAuth(request) { result in
            switch result {
            case .success:
                self.goMain()
            case .failure(let error):
                self.showAlert(message: error.errorMsg)
            }
        }
    }
}
