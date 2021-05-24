//
//  API.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation
import Alamofire

protocol WatsupAPI {
    func postUser(_ request: PostUserRequest, completion: @escaping (Result<PostUsersResponse, APIError>) -> Void)
    func getUser(data: AuthResponse, completion: @escaping ((Result<User, APIError>) -> Void))
    func postAuth(_ request: PostAuthRequest, completion: @escaping (Result<AuthResponse, APIError>) -> Void)
    func putCSForgotPassword(_ request: PutCSForgotPasswordRequest, complection: @escaping (Result<AuthResponse, APIError>) -> Void)
}

class API: WatsupAPI {
    func getUser(data: AuthResponse, completion: @escaping ((Result<User, APIError>) -> Void)) {
        if let uuid = data.identity?.uuid,
           let accessToken = data.accessToken,
           let refreshToken = data.refreshToken {
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultsKey.uuid.rawValue)
            UserDefaults.standard.setValue(accessToken, forKey: KeychainKey.accessToken.rawValue)
            UserDefaults.standard.setValue(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            
            getUser(uuid) { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            completion(.failure(APIError()))
        }
    }
    
    static var shared: API = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 3
        configuration.waitsForConnectivity = true
        let logger = APIEventMonitor()
        let interceptor = APIInterceptor(storage: APITokenStorage())
        let session = Session(configuration: configuration, interceptor: interceptor, eventMonitors: [logger])
        return API(session: session)
    }()
    private let session: Session
    lazy var userUUID: String? = {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    }()
    
    private init(session: Session) {
        self.session = session
    }
    
    private func request<T>(_ model: APIModel, completion: @escaping (Result<T, APIError>) -> Void) where T:Codable {
        session.request(model)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed) {
                        do {
                            let json = try decoder.decode(T.self, from: jsonData)
                            completion(.success(json))
                        } catch {
                            print(error.localizedDescription, #function, #line)
                            completion(.failure(APIError()))
                        }
                    }else{
                        completion(.failure(APIError()))
                    }
                case .failure:
                    let apiError = self.getError(response.data)
                    completion(.failure(apiError))
                }
            }
    }
    
    private func upload<T>(_ model: APIModel, completion: @escaping (Result<T, APIError>) -> Void) where T:Codable {
        session.upload(multipartFormData: { multipart in
            if let image = model.image {
                multipart.append(image, withName: "image", fileName: "image", mimeType: MimeType.Image.jpeg.rawValue)
            }
        }, with: model)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed) {
                    do {
                        let json = try decoder.decode(T.self, from: jsonData)
                        completion(.success(json))
                    } catch {
                        print(error.localizedDescription, #function, #line)
                        completion(.failure(APIError()))
                    }
                }else{
                    completion(.failure(APIError()))
                }
            case .failure:
                let apiError = self.getError(response.data)
                completion(.failure(apiError))
            }
        }
    }
    
    // MARK: - Auth
    /// Login
    func postAuth(_ request: PostAuthRequest, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        API.shared.request(.postAuth(request)) { result in
            completion(result)
        }
    }
    
    func putAuth(completion: @escaping (Result<PutAuthResponse, APIError>) -> Void) {
        API.shared.request(.putAuth) { result in
            completion(result)
        }
    }
    
    func postCSForgotPassword(_ request: PostCSForgotPasswordRequest, completion: @escaping (Result<PostCSForgotPasswordResponse, APIError>) -> Void) {
        API.shared.request(.postCSForgotPassword(request)) { result in
            completion(result)
        }
    }
    
    func putCSForgotPassword(_ request: PutCSForgotPasswordRequest, complection: @escaping (Result<AuthResponse, APIError>) -> Void) {
        API.shared.request(.putCSForgotPassword(request)) { result in
            complection(result)
        }
    }
    
    // MARK: - User
    func getUser(_ uuid: String, completion: @escaping (Result<User, APIError>) -> Void) {
        API.shared.request(.getUser(uuid)) { result in
            completion(result)
        }
    }
    
    func postUser(_ request: PostUserRequest, completion: @escaping (Result<PostUsersResponse, APIError>) -> Void) {
        API.shared.request(.postUser(request)) { result in
            completion(result)
        }
    }
    
    func getUserProfile(_ uuid: String, completion: @escaping (Result<GetUserProfileResponse, APIError>) -> Void) {
        API.shared.request(.getUserProfile(uuid)) { result in
            completion(result)
        }
    }
    
    func putUserProfile(_ uuid: String, request: PutUserProfileRequest, completion: @escaping (Result<Profile, APIError>) -> Void) {
        API.shared.request(.putUserProfile(uuid, request: request)) { (result: Result<Profile, APIError>) in
            switch result {
            case .success(let response):
                DatabaseWorker.shared.putUserProfile(uuid, profile: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func putUserProfileImage(_ uuid: String, request: PutUserProfileImageRequest, completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        API.shared.upload(.putUserProfileImage(uuid, request: request)) { (result: Result<CommonResponse, APIError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    /**
     - Parameters:
        - uuid: 사용자 UUID (nil일 경우 내 UUID)
     */
    func getUserEmotions(uuid: String, completion: @escaping (Result<GetUserEmotionsResponse, APIError>) -> Void) {
        API.shared.request(.getUserEmotions(uuid)) { (result: Result<GetUserEmotionsResponse, APIError>) in
            switch result {
            case .success(let response):
                if let logs = response.logs {
                    DatabaseWorker.shared.setEmotionLogs(logs, of: uuid)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func postEmotion(_ request: PostEmotionRequest, completion: @escaping (Result<Emotion, APIError>) -> Void) {
        API.shared.request(.postEmotion(request)) { (result: Result<Emotion, APIError>) in
            switch result {
            case .success(let response):
                guard let userUUID = self.userUUID else { return }
                DatabaseWorker.shared.setEmotionLogs([response], of: userUUID)
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    // MARK: - Group
    
    func getGroup(_ groupUUID: String, completion: @escaping (Result<Group, APIError>) -> Void) {
        API.shared.request(.getGroup(groupUUID)) { result in
            completion(result)
        }
    }
    
    func getGroupJoin(_ groupUUID: String, completion: @escaping (Result<Group, APIError>) -> Void) {
        API.shared.request(.getGroupJoin(groupUUID)) { (result: Result<Group, APIError>) in
            switch result {
            case .success(let group):
                DatabaseWorker.shared.setGroups([group])
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func postGroups(_ request: PostGroupsRequest, completion: @escaping (Result<PostGroupsResponse, APIError>) -> Void) {
        API.shared.request(.postGroups(request)) { (result: Result<PostGroupsResponse, APIError>) in
            switch result {
            case .success(let response):
                if let name = response.name, let uuid = response.uuid {
                    let group = Group()
                    group.name = name
                    group.uuid = uuid
                    DatabaseWorker.shared.setGroups([group])
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            completion(result)
        }
    }
    
    func postGroupInvite(_ groupUUID: String, _ request: PostGroupInviteRequest, completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        API.shared.request(.postGroupInvite(groupUUID, request)) { (result: Result<CommonResponse, APIError>) in
            completion(result)
        }
    }
    
    func getUserGroup(completion: @escaping (Result<GetUserGroupResponse, APIError>) -> Void) {
        API.shared.request(.getUserGroup) { (result: Result<GetUserGroupResponse, APIError>) in
            switch result {
            case .success(let response):
                DatabaseWorker.shared.setGroups(response.groups)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            completion(result)
        }
    }
    
    func getUserInbox(completion: @escaping (Result<GetUserInboxResponse, APIError>) -> Void) {
        API.shared.request(.getUserInbox) { (result: Result<GetUserInboxResponse, APIError>) in
            completion(result)
        }
    }
    
    func deleteGroups(_ groupUUID: String, completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        API.shared.request(.deleteGroups(groupUUID)) { (result: Result<CommonResponse, APIError>) in
            switch result {
            case .success(let response):
                if response.result == true {
                    DatabaseWorker.shared.deleteGroups(groupUUID)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func getGroupLeave(_ groupUUID: String, completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        API.shared.request(.getGroupLeave(groupUUID)) { (result: Result<CommonResponse, APIError>) in
            switch result {
            case .success(let response):
                if response.result == true {
                    DatabaseWorker.shared.deleteGroups(groupUUID)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    // MARK: - Error
    func getError(_ data: Data?) -> APIError {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = data,
           let json = try? decoder.decode(CommonResponse.self, from: data),
           let errorCode = json.code {
            let apiError = APIError(errorCode: APIError.APIErrorCode(rawValue: errorCode))
            return apiError
        }else{
            // return default error.
            return APIError()
        }
    }
}
