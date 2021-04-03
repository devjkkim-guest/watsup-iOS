//
//  CommonEnums.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import Foundation

/// 감정 타입
enum EmotionType: String, CaseIterable {
    /// 0<=score<=20
    case pouting = "😡"
    /// 20<score<=40
    case crying = "😢"
    /// 40<score<=60
    case neutral = "😐"
    /// 60<score<=80
    case grinning = "😄"
    /// 80<score<=100
    case smilingHeartEyes = "😍"
    
    static func getEmotion(rawValue: Int) -> Self {
        switch rawValue {
        case 0...20:
            return .pouting
        case 21...40:
            return .crying
        case 41...60:
            return .neutral
        case 61...80:
            return .grinning
        case 81...100:
            return .smilingHeartEyes
        default:
            return .grinning
        }
    }
}

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
