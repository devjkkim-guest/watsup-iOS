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

protocol WatsupRepository {
    func removeAll()
    // MARK: - User
    func setUser(_ user: User) throws
    
    // MARK: - Emotion
    func getEmotions(uuid: String) -> Results<Emotion>
    func getUsers(in group: Group) -> Results<User>
    
    // MARK: - Group
    func putGroup(_ groupUUID: String, groupName: String)
}

class DatabaseWorker: WatsupRepository {
    static let shared = DatabaseWorker()
    let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func removeAll() {
        try? realm.write {
            realm.deleteAll()
        }
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
    
    func getUsers(in group: Group) -> Results<User> {
        let keys = Array(group.joinedUsers.compactMap({ $0.user?.uuid }))
        let result = realm.objects(User.self).filter("uuid in %@", keys)
        print(result)
        return result
    }
    
    // MARK: - Emotion
    func getEmotions(uuid: String) -> Results<Emotion> {
        return realm.objects(Emotion.self).filter("userUUID = '\(uuid)'").sorted(byKeyPath: "id", ascending: true)
    }
    
    func getEmotions(from: Date, to: Date) -> Results<Emotion> {
        let timeIntervalFrom = from.timeIntervalSince1970Int
        let timeIntervalTo = to.timeIntervalSince1970Int
        
        return realm.objects(Emotion.self).filter("createdAt >= \(timeIntervalFrom) AND createdAt <= \(timeIntervalTo)")
    }
    
    func setEmotionLogs(_ logs: [Emotion], of userUUID: String) {
        try? realm.write {
            let emotions = Emotion.setCompoundKey(logs: logs, userUUID: userUUID)
            realm.add(emotions, update: .modified)
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
            groups.forEach { group in
                group.joinedUsers.forEach { user in
                    if let uuid = user.user?.uuid,
                       let existingUser = realm.objects(User.self).filter("uuid = '\(uuid)'").first {
                        user.user = existingUser
                    }
                }
            }
            realm.add(groups, update: .modified)
        }
    }
    
    func putGroup(_ groupUUID: String, groupName: String) {
        if let group = realm.objects(Group.self).filter("uuid = '\(groupUUID)'").first {
            try? realm.write {
                group.name = groupName
                realm.add(group, update: .modified)
            }
        }
    }
    
    func deleteGroups(_ groupUUID: String) {
        try? realm.write {
            let group = realm.objects(Group.self).filter("uuid = '\(groupUUID)'")
            realm.delete(group)
        }
    }
}
