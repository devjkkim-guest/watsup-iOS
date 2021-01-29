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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickJoin(_ sender: UIButton) {
        guard let email = tfEmail.text else {
            return
        }
        guard let password = tfPassword.text else {
            return
        }
        
        let deviceToken = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceToken.rawValue)
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        
        let userData = PostUsersRequest(email: email,
                                        password: password,
                                        device_uuid: UUID().uuidString,
                                        device_token: deviceToken ?? "abc",
                                        os_type: OSType.iOS.rawValue,
                                        app_version: appVersion ?? "0")
        API.shared.request(.postUser(userData), responseModel: PostUsersResponse.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                print("no result")
            }
        }
    }
}
