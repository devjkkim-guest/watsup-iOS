//
//  EmotionRequest.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation

struct PostEmotionRequest: Codable {
    let message: String
    let emotionType: Int
    let score: Int
    let createdAt: Double
    let timeRecognizable: Double
}
