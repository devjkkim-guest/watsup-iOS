//
//  APITokenStorage.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

class APITokenStorage: TokenStorage {
    var accessToken: String? = {
        return UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue)
    }()
    
    var refreshToken: String? = {
        return UserDefaults.standard.string(forKey: KeychainKey.refreshToken.rawValue)
    }()
    
    func removeAllTokens() {
        accessToken = nil
        refreshToken = nil
    }
}
