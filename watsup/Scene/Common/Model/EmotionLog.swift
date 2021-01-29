//
//  EmotionModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import UIKit

protocol EmotionLog {
    var message: String? { get set }
    var emotion: EmotionType { get set }
    
    init(message: String?, emotion: EmotionType)
}

class EmotionModel: EmotionLog {
    var message: String?
    
    var emotion: EmotionType
    
    required init(message: String?, emotion: EmotionType) {
        self.message = message
        self.emotion = emotion
    }
}
