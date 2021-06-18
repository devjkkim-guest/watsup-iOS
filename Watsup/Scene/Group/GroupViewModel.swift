//
//  GroupViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/25.
//

import Foundation
import RealmSwift

let groupViewModelId = "groupViewModelId"

class GroupViewModel: BaseViewModel {
    var id: String = groupViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    private(set) var group: Group?
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func setGroup(_ group: Group) {
        self.group = group
    }
    
    func checkIfIAmMaster() -> Bool {
        guard let group = group else { return false }
        return group.joinedUsers.contains { joinedUser in
            return joinedUser.user?.uuid == uuid && joinedUser.userStatus == .master
        }
    }
    
    func putGroup(_ groupUUID: String, request: PutGroupRequest, completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        api.putGroup(groupUUID, request: request) { result in
            switch result {
            case .success(let data):
                self.repository.putGroup(groupUUID, groupName: request.groupName)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getGroupJoinedUserEmotions(group: Group) {
        group.joinedUsers.forEach({ joinedUser in
            guard let uuid = joinedUser.user?.uuid else { return }
            API.shared.getUserEmotions(uuid: uuid) { _ in
                return
            }
        })
    }
    
    func getJoinedUsers() -> Results<User>? {
        guard let group = group else { return nil }
        return repository.getUsers(in: group)
    }
    
    func inviteUser(email: String) {
        guard let groupUUID = group?.uuid else { return }
        let request = PostGroupInviteRequest(userEmail: email)
        API.shared.postGroupInvite(groupUUID, request) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureGroup(name: String, completion: @escaping ((Result<CommonResponse, APIError>) -> Void)) {
        guard let groupUUID = group?.uuid else { return }
        let request = PutGroupRequest(groupName: name)
        api.putGroup(groupUUID, request: request) { result in
            self.repository.putGroup(groupUUID, groupName: name)
            completion(result)
        }
    }
    
    func getEmotions(userUUID: String) -> Results<Emotion> {
        return repository.getEmotions(uuid: userUUID)
    }
}
