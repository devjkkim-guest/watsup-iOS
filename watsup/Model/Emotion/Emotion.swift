//
//  Emotion.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation
import RealmSwift

class Emotion: Object, Codable {
    @objc dynamic var emotion_type: Int = 0
    @objc dynamic var message: String?
    @objc dynamic var score: Int = 0
}
