//
//  AuthJoinViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/17.
//

import UIKit

class AuthJoinViewModel {
    func postUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let deviceToken = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceToken.rawValue)
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let languageCode = Locale.preferredLanguages.first ?? "en_US"
        let userData = PostUserRequest(email: email,
                                        gmtTzOffset: 0, password: password,
                                        deviceUuid: UUID().uuidString,
                                        deviceToken: deviceToken ?? "abc",
                                        osType: OSType.iOS.rawValue,
                                        appVersion: appVersion ?? "0",
                                        languageCode: languageCode)
        API.shared.postUser(userData) { result in
            switch result {
            case .success(_):
                let req = PostAuthRequest(email: email, password: password)
                self.postAuth(req) { result in
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func postAuth(_ request: PostAuthRequest, completion: @escaping (Bool) -> Void) {
        let viewModel = AuthLoginViewModel()
        viewModel.postAuth(request) { result in
            completion(result)
        }
    }
}
