//
//  AuthJoinViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit

class AuthJoinViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var guideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingWhenTapBackground()
        guideLabel.text = "Join.Guide.Email".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickJoin(_ sender: UIButton) {
        guard let email = tfEmail.text else { return }
        guard let password = tfPassword.text else { return }
        
        let viewModel: AuthViewModel = Container.shared.resolve(id: authViewModelId)
        viewModel.postUser(email: email, password: password) { result in
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
