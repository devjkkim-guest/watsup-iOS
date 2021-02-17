//
//  CommonResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

struct ErrorResponse: Codable {
    var code: Int?
    var message: String?
    var status: String?
}

struct DeviceResponse: Codable {
    var appVersion: String?
    var deviceToken: String?
    var deviceUuid: String?
    var osType: String
}

struct ProfileResponse: Codable {
    var image: String?
    var nickname: String?
}

struct Identity: Codable {
    var email: String?
    var uuid: String?
    var profile: ProfileResponse?
}

struct GroupResponse: Codable {
    let name: String
    let uuid: String
}
