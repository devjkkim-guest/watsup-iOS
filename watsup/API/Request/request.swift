//
//  request.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation

struct PostUsersRequest: Codable {
    let email: String
    let password: String
    let device_uuid: String
    var device_token: String?
    let os_type: String
    let app_version: String
}

struct PostAuthRequest: Codable {
    let email: String
    let password: String
}