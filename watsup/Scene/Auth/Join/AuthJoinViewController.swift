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
        endEditingWhenTapBackground()
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
        let languageCode = Locale.preferredLanguages.first ?? "en_US"
        let userData = PostUserRequest(email: email,
                                        gmt_tz_offset: 0, password: password,
                                        device_uuid: UUID().uuidString,
                                        device_token: deviceToken ?? "abc",
                                        os_type: OSType.iOS.rawValue,
                                        app_version: appVersion ?? "0",
                                        language_code: languageCode)
        API.shared.postUser(userData) { result in
            switch result {
            case .success(let data):
                print(data)
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
