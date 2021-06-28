//
//  Emotion.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation
import RealmSwift

class Emotion: Object, Codable {
    @objc dynamic var compoundKey: String? = ""
    @objc dynamic var userUUID: String? = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var emotionType: Int = 0
    @objc dynamic var message: String?
    @objc dynamic var score: Int = 0
    @objc dynamic var createdAt: Double = 0
    
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
