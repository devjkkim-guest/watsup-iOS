//
//  User.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/17.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    enum Status: Int {
        case invited = 0
        case member
        case master
    }
    
    @objc dynamic var email: String?
    @objc dynamic var status = 0
    @objc dynamic var uuid: String?
    @objc dynamic var profile: Profile?
    var emotions = List<Emotion>()
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status) ?? 0
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.profile = try container.decodeIfPresent(Profile.self, forKey: .profile)
        if let emotions = try container.decodeIfPresent(List<Emotion>.self, forKey: .emotions) {
            self.emotions = emotions
        }
    }
}

class JoinedUsers: Object, Codable {
    @objc dynamic var createdAt: Double = 0
    @objc dynamic var status: Int = 0
    @objc dynamic var user: User?
}

class Profile: Object, Codable {
    @objc dynamic var nickname: String?
    @objc dynamic var image: String?
}
