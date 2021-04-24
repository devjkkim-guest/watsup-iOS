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
    @objc dynamic var status: String?
    @objc dynamic var uuid: String?
    @objc dynamic var profile: Profile?
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}

class Profile: Object, Codable {
    @objc dynamic var nickname: String?
    @objc dynamic var image: String?
}
