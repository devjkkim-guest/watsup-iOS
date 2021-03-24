//
//  EmotionModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import UIKit

class EmotionLog {
    var message: String?
    var emotion: EmotionType
    
    required init(message: String?, emotion: EmotionType) {
        self.message = message
        self.emotion = emotion
    }
}
