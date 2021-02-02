//
//  AuthLoginViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit

class AuthLoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    let viewModel = AuthLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        guard let email = tfEmail.text else {
            return
        }
        guard let password = tfPassword.text else {
            return
        }
        
        let body = PostAuthRequest(email: email, password: password)
        requestLogin(body: body) { _ in
            
        }
    }
    
    func requestLogin(body: PostAuthRequest, completion: @escaping (Bool) -> Void) {
        API.shared.request(.postAuth(body), responseModel: PostAuthResponse.self) { result in
            switch result {
            case .success(let data):
                if self.viewModel.addUser(data: data) {
                    self.goMain()
                }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            case .none:
                print("no result")
                completion(false)
            }
        }
    }
    
    func goMain() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
            
        }
    }
}
