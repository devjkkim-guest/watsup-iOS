//
//  User.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/17.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @objc dynamic var email: String?
    @objc dynamic var uuid: String?
    @objc dynamic var profile: Profile?
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.profile = try container.decodeIfPresent(Profile.self, forKey: .profile)
    }
}

class JoinedUser: Object, Codable {
    enum Status: Int {
        case invited = 0
        case member
        case master
    }
    
    @objc dynamic var createdAt: Double = 0
    @objc dynamic var status: Int = 0
    @objc dynamic var user: User?
    
    // rawValue: status를 Status Enum으로 변환
    lazy var userStatus: Status? = {
        return Status(rawValue: status)
    }()
    
    override class func ignoredProperties() -> [String] {
        return ["userStatus"]
    }
}

class Profile: Object, Codable {
    @objc dynamic var nickname: String?
    @objc dynamic var image: String?
    @objc dynamic var updatedAt: Double
}
