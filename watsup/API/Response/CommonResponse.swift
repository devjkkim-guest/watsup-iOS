//
//  CommonResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

protocol ErrorProtocol: Codable {
    var code: Int? { get set }
    var message: String? { get set }
    var status: String? { get set }
}

struct ErrorResponse: ErrorProtocol {
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

struct EmotionLogResponse: Codable {
    let emotionType: Int
    let message: String
    let score: Int
}
