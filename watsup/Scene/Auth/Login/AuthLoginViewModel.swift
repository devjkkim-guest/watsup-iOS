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
        if let uuid = data.identity?.uuid {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
        }
        if let accessToken = data.accessToken {
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
        }
        if let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        }
        return true
    }
}
