//
//  request.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation

struct PostUserRequest: Codable {
    let email: String
    let gmtTzOffset: Int
    let password: String
    let deviceUuid: String
    var deviceToken: String
    let osType: String
    let appVersion: String
    let languageCode: String
}

struct PutUserProfileRequest: Codable {
    let nickname: String
}

struct PutUserProfileImageRequest: Codable {
    let image: Data
}

struct PostAuthRequest: Codable {
    let email: String
    let password: String
}
