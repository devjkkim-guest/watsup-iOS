//
//  DatabaseWorker.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation
import RealmSwift

enum DatabaseError: Error {
    case writeError
    case insufficientDataError
}

class DatabaseWorker {
    static let shared = DatabaseWorker()
    let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    // MARK: - User
    func getMyProfile() -> Results<User>? {
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
            return realm.objects(User.self).filter("uuid = '\(uuid)'")
        }else{
            return nil
        }
    }
    
    func setUser(_ user: User) throws {
        do {
            try realm.write {
                realm.add(user, update: .modified)
            }
        }catch{
            print(error.localizedDescription)
            throw DatabaseError.writeError
        }
    }
    
    func putUserProfile(_ uuid: String, profile: Profile) {
        try? realm.write {
            if let user = realm.objects(User.self).filter("uuid = '\(uuid)'").first {
                user.profile = profile
            }
        }
    }
    
    // MARK: - Emotion
    func getEmotionList() -> Results<Emotion> {
        return realm.objects(Emotion.self)
    }
    
    func setEmotionLogs(_ logs: [Emotion]) {
        try? realm.write {
            realm.add(logs, update: .modified)
        }
    }
    
    // MARK: - Group
    func getGroups(_ groupUUID: String? = nil) -> Results<Group> {
        if let groupUUID = groupUUID {
            return realm.objects(Group.self).filter("uuid = '\(groupUUID)'")
        }else{
            return realm.objects(Group.self)
        }
    }
    
    func setGroups(_ groups: [Group]) {
        try? realm.write {
            realm.add(groups, update: .modified)
        }
    }
    
    func deleteGroups(_ groupUUID: String) {
        try? realm.write {
            let group = realm.objects(Group.self).filter("uuid = '\(groupUUID)'")
            realm.delete(group)
        }
    }
}
