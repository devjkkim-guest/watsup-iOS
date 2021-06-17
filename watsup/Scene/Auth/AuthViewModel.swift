//
//  AuthLoginViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation
import RxSwift

public let authViewModelId = "authViewModelId"

class AuthViewModel: BaseViewModel {
    enum EmailStatus {
        case empty
        case valid
        case notValid
    }
    enum PasswordStatus {
        case empty
        case match
        case notMatch
    }
    let id: String = authViewModelId
    let api: WatsupAPI
    let repository: WatsupRepository
    let isValidEmail = BehaviorSubject<EmailStatus>(value: .empty)
    let isEqualPassword = BehaviorSubject<PasswordStatus>(value: .empty)
    
    public var uuid: String? = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func postUser(email: String, password: String, completion: @escaping (Result<User, APIError>) -> Void) {
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
        api.postUser(userData) { result in
            switch result {
            case .success(_):
                let req = PostAuthRequest(email: email, password: password)
                self.postAuth(req) { result in
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    /// write user data on db
    func getUser(data: AuthResponse, completion: @escaping ((Result<User, APIError>) -> Void)) {
        if let uuid = data.identity?.uuid,
           let accessToken = data.accessToken,
           let refreshToken = data.refreshToken {
            self.uuid = uuid
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            api.getUser(uuid: uuid) { result in
                switch result {
                case .success(let user):
                    do {
                        try self.repository.setUser(user)
                        completion(.success(user))
                    } catch {
                        completion(.failure(APIError(errorType: .others(type: .notDefined), errorCode: -1)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(APIError(errorType: .others(type: .notDefined), errorCode: -1)))
        }
    }
    
    func postAuth(_ request: PostAuthRequest, completion: @escaping ((Result<User, APIError>) -> Void)) {
        api.postAuth(request) { result in
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
    
    func putCSForgotPassword(_ request: PutCSForgotPasswordRequest, complection: @escaping (Result<AuthResponse, APIError>) -> Void) {
        api.putCSForgotPassword(request, complection: complection)
    }
}
