//
//  AuthLoginViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

class AuthLoginViewModel {
    /// write user data on db
    func addUser(data: PostAuthResponse) -> Bool {
        if let uuid = data.identity?.uuid,
           let accessToken = data.accessToken,
           let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            return true
        }else{
            return false
        }
    }
    
    func postAuth(_ request: PostAuthRequest, completion: @escaping (Bool) -> Void) {
        API.shared.postAuth(request) { result in
            switch result {
            case .success(let data):
                guard self.addUser(data: data) else {
                    completion(false)
                    return
                }
                if let uuid = data.identity?.uuid {
                    self.getUser(uuid: uuid) { result in
                        switch result {
                        case .success(let user):
                            do {
                                try DatabaseWorker.shared.setUser(user)
                                completion(true)
                            }catch{
                                print(error.localizedDescription)
                                completion(false)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func getUser(uuid: String, completion: @escaping ((Result<User, APIError>) -> Void)) {
        API.shared.getUser(uuid) { result in
            completion(result)
        }
    }
}
