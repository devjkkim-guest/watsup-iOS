//
//  PostUsersResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import Foundation

struct PostUsersResponse: Codable {
    var device: DeviceResponse?
    var email: String?
    var profile: ProfileResponse?
    var uuid: String?
}
