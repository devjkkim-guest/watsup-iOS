//
//  EmotionRequest.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation

struct PostEmotionRequest: Codable {
    let message: String
    let emotion_type: Int
    let score: Int
    let created_at: Double
}
