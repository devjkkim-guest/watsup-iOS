//
//  AuthLoginViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

class AuthLoginViewModel {
    /// write user data on db
    func addUser(data: PostAuthResponse) -> Bool {
        if let uuid = data.identity?.uuid,
           let accessToken = data.accessToken,
           let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            return true
        }else{
            return false
        }
    }
    
    func getUser(uuid: String, completion: @escaping ((User) -> Void)) {
        API.shared.getUser(uuid) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
