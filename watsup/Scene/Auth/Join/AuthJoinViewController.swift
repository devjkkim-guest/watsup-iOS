//
//  AuthJoinViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import UIKit

class AuthJoinViewController: BaseAuthViewController {

    @IBOutlet weak var tfEmail: WUTextField!
    @IBOutlet weak var tfPassword: WUTextField!
    @IBOutlet weak var tfConfirmPassword: WUTextField!
    @IBOutlet weak var guideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingWhenTapBackground()
        guideLabel.text = "Join.Guide.Email".localized
        
        bottomButton.button.setTitle("Button.Join".localized, for: .normal)
        bottomButton.button.addTarget(self, action: #selector(onClickJoin(_:)), for: .touchUpInside)
    }
    
    @objc func onClickJoin(_ sender: UIButton) {
        guard let email = tfEmail.text else { return }
        guard let password = tfPassword.text else { return }
        
        WUProgress.show()
        let viewModel: AuthViewModel = Container.shared.resolve(id: authViewModelId)
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
