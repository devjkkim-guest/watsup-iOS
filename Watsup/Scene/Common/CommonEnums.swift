//
//  CommonEnums.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import Foundation

/// UserDefaults Keys
enum UserDefaultsKey: String {
    case uuid
    case deviceToken
}

/// Keychain Keys
enum KeychainKey: String {
    case accessToken
    case refreshToken
}

/// os type
enum OSType: String {
    case iOS = "1"
    case Android = "2"
}
