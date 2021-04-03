//
//  API.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation
import Alamofire

class API {
    static var shared: API = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 1
        configuration.waitsForConnectivity = true
        let logger = APIEventMonitor()
        let interceptor = APIInterceptor(storage: APITokenStorage())
        let session = Session(configuration: configuration, interceptor: interceptor, eventMonitors: [logger])
        return API(session: session)
    }()
    private let session: Session
    
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
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed),
                       let json = try? decoder.decode(T.self, from: jsonData) {
                        completion(.success(json))
                    }else{
                        completion(.failure(APIError()))
                    }
                case .failure(_):
                    let apiError = self.getError(response.data)
                    completion(.failure(apiError))
                }
            }
    }
    
    // MARK: - Auth
    
    func postAuth(_ request: PostAuthRequest, completion: @escaping (Result<PostAuthResponse, APIError>) -> Void) {
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
    
    func putCSForgotPassword(_ request: PutCSForgotPasswordRequest, complection: @escaping (Result<PutCSForgotPasswordResponse, APIError>) -> Void) {
        API.shared.request(.putCSForgotPassword(request)) { result in
            complection(result)
        }
    }
    
    // MARK: - User
    
    func getUser(_ request: GetUserRequest, completion: @escaping (Result<GetUsersResponse, APIError>) -> Void) {
        API.shared.request(.getUser(request)) { result in
            completion(result)
        }
    }
    
    func postUser(_ request: PostUserRequest, completion: @escaping (Result<PostUsersResponse, APIError>) -> Void) {
        API.shared.request(.postUser(request)) { result in
            completion(result)
        }
    }
    
    func getUserProfile(_ request: GetUserProfileRequest, completion: @escaping (Result<GetUserProfileResponse, APIError>) -> Void) {
        API.shared.request(.getUserProfile(request)) { result in
            completion(result)
        }
    }
    
    func getUserEmotions(completion: @escaping (Result<GetUserEmotionsResponse, APIError>) -> Void) {
        API.shared.request(.getUserEmotions) { (result: Result<GetUserEmotionsResponse, APIError>) in
            switch result {
            case .success(let response):
                if let logs = response.logs {
                    DatabaseWorker.shared.setEmotionLogs(logs)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func postEmotion(_ request: PostEmotionRequest, completion: @escaping (Result<PostEmotionResponse, APIError>) -> Void) {
        API.shared.request(.postEmotion(request)) { (result: Result<PostEmotionResponse, APIError>) in
            switch result {
            case .success(let response):
                if response.result {
                    let emotion = Emotion()
                    emotion.message = request.message
                    emotion.emotionType = request.emotion_type
                    emotion.score = request.score
                    DatabaseWorker.shared.setEmotionLogs([emotion])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    // MARK: - Group

    func getGroup(_ request: GetGroupRequest, completion: @escaping (Result<GetGroupsResponse, APIError>) -> Void) {
        API.shared.request(.getGroup(request)) { result in
            completion(result)
        }
    }
    
    func postGroups(_ request: PostGroupsRequest, completion: @escaping (Result<PostGroupsResponse, APIError>) -> Void) {
        API.shared.request(.postGroups(request)) { result in
            completion(result)
        }
    }
    
    func getUserGroup(completion: @escaping (Result<GetUserGroupResponse, APIError>) -> Void) {
        API.shared.request(.getUserGroup) { result in
            completion(result)
        }
    }
    
    // MARK: - Error
    func getError(_ data: Data?) -> APIError {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = data,
           let json = try? decoder.decode(ErrorResponse.self, from: data) {
            let apiError = APIError(errorCode: json.code)
            return apiError
        }else{
            // return default error.
            return APIError()
        }
    }
}
