//
//  APIModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation
import Alamofire

enum APIModel: URLRequestConvertible {
    
    /** Auth */
    case postAuth(_ request: PostAuthRequest)
    case putAuth
    
    /** User */
    case getUser(_ request: GetUserRequest)
    case postUser(_ request: PostUserRequest)
    case getUserProfile(_ request: GetUserProfileRequest)
    case getUserEmotions
    case postEmotion(_ request: PostEmotionRequest)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPasswordRequest)
    case putCSForgotPassword(_ request: PutCSForgotPasswordRequest)
    
    /** Group */
    case getGroup(_ request: GetGroupRequest)
    case postGroups(_ request: PostGroupsRequest)
    case getUserGroup
    
    static let baseUrl = "http://localhost:5000"
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .putAuth:
            return .put
        case .postEmotion(_):
            return .post
        default:
            break
        }

        if parameters == nil {
            return .get
        }else{
            return .post
        }
    }
    
    var userUuid: String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    }
    
    // MARK: - Path
    private var path: String? {
        switch self {
        /** User */
        case .getUser(let uuid):
            return "/users/\(uuid.uuid)"
        case .getUserProfile(let uuid):
            return "/users/\(uuid)/profile"
        case .postUser(_):
            return "/users"
        case .getUserEmotions:
            if let userUuid = userUuid {
                return "/users/\(userUuid)/emotions"
            }else{
                return nil
            }
        case .postEmotion:
            if let userUuid = userUuid {
                return "/users/\(userUuid)/emotions"
            }else{
                return nil
            }
            
        /** Auth */
        case .postAuth(_):
            return "/auth"
        case .putAuth:
            return "/auth"
        /** Customer Service */
        case .postCSForgotPassword,
             .putCSForgotPassword:
            return "/cs/forgot-password"
            
        /** Group */
        case .postGroups:
            return "/groups"
        case .getUserGroup:
            if let userUuid = userUuid {
                return "/users/\(userUuid)/groups"
            }else{
                return nil
            }
        case .getGroup(let group):
            return "/groups/\(group.uuid)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Data? {
        switch self {
        /** Users */
        case .postUser(let param):
            return encode(parameter: param)
        case .postAuth(let param):
            return encode(parameter: param)
        case .putAuth:
            return nil
        case .putCSForgotPassword(let param):
            return encode(parameter: param)
        case .postCSForgotPassword(let param):
            return encode(parameter: param)
        case .getUserEmotions:
            return nil
        case .postEmotion(let param):
            return encode(parameter: param)
            
        /** Groups */
        case .postGroups(let param):
            return encode(parameter: param)
        case .getUserGroup,
             .getGroup,
             .getUser,
             .getUserProfile:
            return nil
        }
    }
    
    private var urlQuery: Codable? {
        switch self {
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        var commonHeaders: HTTPHeaders = [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                                          HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue]
        switch self {
        case .putAuth:
            if let refreshToken = UserDefaults.standard.string(forKey: KeychainKey.refreshToken.rawValue) {
                let value = "Bearer \(refreshToken)"
                commonHeaders.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            return commonHeaders
        case .getUser,
             .getUserProfile,
             .getUserGroup,
             .postGroups,
             .getGroup,
             .getUserEmotions,
             .postEmotion:
            if let accessToken = UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue) {
                let value = "Bearer \(accessToken)"
                commonHeaders.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            return commonHeaders
        default:
            return commonHeaders
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        if let path = path {
            var urlString = APIModel.baseUrl.appending(path)
            
            if let urlQuery = urlQuery,
               let query = urlQuery.asDictionary()?.map({ "\($0.key)=\($0.value)"}) {
                let queries = query.reduce("?") { $0 + $1 }
                urlString = urlString.appending(queries)
            }
            
            var urlRequest = URLRequest(url: try urlString.asURL())
            urlRequest.headers = headers
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpBody = parameters
            
            return urlRequest
        }else{
            throw APIModelError.noPath
        }
    }
    
    func encode<T:Codable>(parameter: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(parameter)
    }
}

enum APIModelError: Error {
    case noPath
}
