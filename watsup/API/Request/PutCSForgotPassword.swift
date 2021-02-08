//
//  PutCSForgotPasswordRequest.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/02.
//

import Foundation

struct PutCSForgotPasswordRequest: Codable {
    let verification_code: Int
}
