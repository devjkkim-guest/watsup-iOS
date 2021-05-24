//
//  Group.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/13.
//

import Foundation
import RealmSwift

class Group: Object, Codable {
    @objc dynamic var createdAt: Double = 0
    @objc dynamic var uuid: String?
    var joinedUsers = List<JoinedUser>()
    @objc dynamic var name: String?
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}
