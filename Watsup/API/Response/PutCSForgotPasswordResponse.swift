//
//  PutCSForgotPasswordResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import Foundation

struct AuthResponse: Codable {
    var accessToken: String?
    var identity: Identity?
    var refreshToken: String?
}
