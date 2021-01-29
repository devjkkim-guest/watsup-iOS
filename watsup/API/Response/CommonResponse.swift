//
//  CommonResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

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
}
