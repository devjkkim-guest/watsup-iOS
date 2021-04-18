//
//  request.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation

struct PostUserRequest: Codable {
    let email: String
    let gmt_tz_offset: Int
    let password: String
    let device_uuid: String
    var device_token: String
    let os_type: String
    let app_version: String
    let language_code: String
}

struct PutUserProfileRequest: Codable {
    let nickname: String
}

struct PostAuthRequest: Codable {
    let email: String
    let password: String
}
