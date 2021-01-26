//
//  request.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation

struct PostUsers: Codable {
    let password: String
    let device_uuid: String
    let device_token: String
    let os_type: String
    let email: String
    let app_version: String
}

extension Encodable {
  func asDictionary() -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
    return dictionary
  }
}
