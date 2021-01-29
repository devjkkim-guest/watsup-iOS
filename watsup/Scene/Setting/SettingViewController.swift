//
//  SettingViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
            API.shared.request(.getUser(uuid: uuid), responseModel: GetUsersResponse.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                case .none:
                    print("result none")
                }
            }
            
            API.shared.request(.getUserProfile(uuid: uuid), responseModel: GetUserProfileResponse.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                case .none:
                    print("result none")
                }
            }
        }
    }
}
