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
    func setUser(_ user: User) throws
}

class DatabaseWorker: WatsupRepository {
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
    func getEmotionList(uuid: String) -> List<Emotion>? {
        return realm.objects(User.self).filter("uuid = '\(uuid)'").first?.emotions
    }
    
    func setEmotionLogs(_ logs: [Emotion], of userUuid: String) {
        try? realm.write {
            if let user = realm.objects(User.self).filter("uuid = '\(userUuid)'").first {
                logs.forEach { emotion in
                    if user.emotions.first(where: { $0.id == emotion.id }) == nil {
                        user.emotions.append(emotion)
                    }
                }
                realm.add(user, update: .modified)
            }
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
    
    func deleteGroups(_ groupUUID: String) {
        try? realm.write {
            let group = realm.objects(Group.self).filter("uuid = '\(groupUUID)'")
            realm.delete(group)
        }
    }
}
