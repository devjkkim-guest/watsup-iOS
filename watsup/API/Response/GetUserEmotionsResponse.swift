//
//  GetUserEmotionsResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/24.
//

import Foundation

struct GetUserEmotionsResponse: ErrorProtocol {
    var code: Int?
    var message: String?
    var status: String?
    let logs: Array<EmotionLogResponse>
}
