//
//  Emotion.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import UIKit
import RealmSwift

/// 감정 타입
enum EmotionType: String, CaseIterable {
    /// 0<=score<=20
    case pouting = "😡"
    /// 20<score<=40
    case crying = "😢"
    /// 40<score<=60
    case neutral = "😐"
    /// 60<score<=80
    case grinning = "😄"
    /// 80<score<=100
    case smilingHeartEyes = "😍"
    
    static func getEmotion(rawValue: Int) -> Self {
        switch rawValue {
        case 0...20:
            return .pouting
        case 21...40:
            return .crying
        case 41...60:
            return .neutral
        case 61...80:
            return .grinning
        case 81...100:
            return .smilingHeartEyes
        default:
            return .grinning
        }
    }
    
    func getValue<T: Numeric>() -> T {
        switch self {
        case .pouting:
            return 10 as T
        case .crying:
            return 30 as T
        case .neutral:
            return 50 as T
        case .grinning:
            return 70 as T
        case .smilingHeartEyes:
            return 90 as T
        }
    }
    
    func getColors() -> UIColor {
        switch self {
        case .pouting:
            return UIColor(red: 44/255, green: 100/255, blue: 197/255, alpha: 1)
        case .crying:
            return UIColor(red: 33/255, green: 114/255, blue: 158/255, alpha: 1)
        case .neutral:
            return UIColor(red: 41/255, green: 137/255, blue: 159/255, alpha: 1)
        case .grinning:
            return UIColor(red: 53/255, green: 171/255, blue: 160/255, alpha: 1)
        case .smilingHeartEyes:
            return UIColor(red: 128/255, green: 222/255, blue: 175/255, alpha: 1)
        }
    }
}

class Emotion: Object, Codable {
    @objc dynamic var compoundKey: String? = ""
    @objc dynamic var userUUID: String? = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var emotionType: Int = 0
    @objc dynamic var message: String?
    @objc dynamic var score: Int = 0
    @objc dynamic var createdAt: Int = 0
    
    override class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    override class func indexedProperties() -> [String] {
        return ["userUUID", "createdAt"]
    }
    
    func setCompoundKey(id: Int, userUUID: String) {
        self.userUUID = userUUID
        self.id = id
        self.compoundKey = "\(userUUID)_\(id)"
    }
    
    func getCompoundKey(id: Int, userUUID: String) -> String {
        return "\(userUUID)_\(id)"
    }
    
    class func setCompoundKey(logs: [Emotion], userUUID: String) -> [Emotion] {
        logs.forEach { $0.setCompoundKey(id: $0.id, userUUID: userUUID) }
        return logs
    }
}
