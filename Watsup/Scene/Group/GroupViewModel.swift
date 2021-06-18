//
//  GroupViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/25.
//

import Foundation

let groupViewModelId = "groupViewModelId"

class GroupViewModel: BaseViewModel {
    var id: String = groupViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func checkIfIAmMaster(in group: Group?) -> Bool {
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
}
