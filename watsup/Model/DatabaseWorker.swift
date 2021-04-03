//
//  DatabaseWorker.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/03.
//

import Foundation
import RealmSwift

class DatabaseWorker {
    static let shared = DatabaseWorker()
    let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func getEmotionList() -> Results<Emotion> {
        return realm.objects(Emotion.self)
    }
    
    func setEmotionLogs(_ logs: [Emotion]) {
        try? realm.write {
            realm.add(logs)
        }
    }
}
