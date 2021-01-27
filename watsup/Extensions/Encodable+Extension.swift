//
//  Encodable+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import Foundation

extension Encodable {
  func asDictionary() -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
    return dictionary
  }
}
