//
//  AuthLoginViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation

class AuthLoginViewModel {
    /// write user data on db
    func getUser(data: PostAuthResponse, completion: @escaping ((Result<User, APIError>) -> Void)) {
        if let uuid = data.identity?.uuid,
           let accessToken = data.accessToken,
           let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            
            API.shared.getUser(uuid) { result in
                switch result {
                case .success(let user):
                    do {
                        try DatabaseWorker.shared.setUser(user)
                        completion(.success(user))
                    }catch{
                        print(error.localizedDescription)
                        completion(.failure(APIError()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            completion(.failure(APIError()))
        }
    }
    
    func postAuth(_ request: PostAuthRequest, completion: @escaping ((Result<User, APIError>) -> Void)) {
        API.shared.postAuth(request) { result in
            switch result {
            case .success(let data):
                self.getUser(data: data) { result in
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
