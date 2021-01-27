//
//  Response.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import Foundation

struct PostUsersResponse: Codable {
    let email: String
    let password: String
    let device_uuid: String
    var device_token: String?
    let os_type: String
    let app_version: String
}
