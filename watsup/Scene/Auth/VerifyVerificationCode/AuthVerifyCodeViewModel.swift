//
//  AuthVerifyCodeViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import Foundation

class AuthVerifyCodeViewModel {
    func addUser(_ data: PutCSForgotPasswordResponse) {
        if let uuid = data.identity?.uuid {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
        }
        if let accessToken = data.accessToken {
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
        }
        if let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        }
    }
}
