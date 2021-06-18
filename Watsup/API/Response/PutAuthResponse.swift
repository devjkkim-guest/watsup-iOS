//
//  PutAuthResponse.swift
//  watsup
//
//  Created by ashon on 2021/03/30.
//

import Foundation

struct PutAuthResponse: Codable {
    var accessToken: String?
    var identity: Identity?
    var refreshToken: String?
}
