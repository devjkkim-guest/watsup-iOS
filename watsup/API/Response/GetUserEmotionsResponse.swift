//
//  GetUserEmotionsResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/24.
//

import Foundation
import RealmSwift

struct GetUserEmotionsResponse: Codable {
    var logs: [Emotion]?
}
