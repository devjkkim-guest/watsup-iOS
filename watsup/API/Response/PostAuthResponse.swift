//
//  PostAuthResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

struct PostAuthResponse: Codable {
    var accessToken: String?
    var identity: Identity?
    var refreshToken: String?
}
