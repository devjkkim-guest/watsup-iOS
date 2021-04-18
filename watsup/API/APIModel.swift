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
    /// 로그인
    case postAuth(_ request: PostAuthRequest)
    /// JWT 토큰 갱신
    case putAuth
    
    /** User */
    case getUser(_ uuid: String)
    case postUser(_ request: PostUserRequest)
    case getUserProfile(_ uuid: String)
    case putUserProfile(_ uuid: String, request: PutUserProfileRequest)
    case getUserEmotions(_ uuid: String? = nil)
    case postEmotion(_ request: PostEmotionRequest)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPasswordRequest)
    case putCSForgotPassword(_ request: PutCSForgotPasswordRequest)
    
    /** Group */
    case getGroup(_ groupUUID: String)
    case postGroups(_ request: PostGroupsRequest)
    case getUserGroup
    case getUserInbox
    case deleteGroups(_ groupUUID: String)
    
    static let baseUrl = "http://dev.team726.com:8000"
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getUser,
             .getUserProfile,
             .getUserEmotions,
             .getGroup,
             .getUserGroup,
             .getUserInbox:
            return .get
        case .putUserProfile,
             .putAuth,
             .putCSForgotPassword:
            return .put
        case .postEmotion,
             .postAuth,
             .postUser,
             .postGroups,
             .postCSForgotPassword:
            return .post
        case .deleteGroups:
            return .delete
        }
    }
    
    var userUUID: String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    }
    
    // MARK: - Path
    private var path: String? {
        switch self {
        /** User */
        case .getUser(let uuid):
            return "/users/\(uuid)"
        case .getUserProfile(let uuid):
            return "/users/\(uuid)/profile"
        case .postUser:
            return "/users"
        case .putUserProfile(let uuid, _):
            return "/users/\(uuid)/profile"
        case .getUserEmotions(let uuid):
            if let uuid = uuid {
                return "/users/\(uuid)/emotions"
            }else{
                if let userUUID = userUUID {
                    return "/users/\(userUUID)/emotions"
                }else{
                    return nil
                }
            }
        case .postEmotion:
            if let userUUID = userUUID {
                return "/users/\(userUUID)/emotions"
            }else{
                return nil
            }
            
        /** Auth */
        case .postAuth:
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
            if let userUUID = userUUID {
                return "/users/\(userUUID)/groups"
            }else{
                return nil
            }
        case .deleteGroups(let uuid):
            return "/groups/\(uuid)"
        case .getGroup(let uuid):
            return "/groups/\(uuid)"
        case .getUserInbox:
            if let userUUID = userUUID {
                return "/users/\(userUUID)/inbox"
            }else{
                return nil
            }
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
        case .putUserProfile(_, let param):
            return encode(parameter: param)
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
             .getUserProfile,
             .getUserInbox,
             .deleteGroups:
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
             .putUserProfile,
             .getUserGroup,
             .postGroups,
             .getGroup,
             .getUserEmotions,
             .postEmotion,
             .getUserInbox,
             .deleteGroups:
            if let accessToken = UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue) {
                let value = "Bearer \(accessToken)"
                commonHeaders.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            // JWT included
            return commonHeaders
        case .postAuth,
             .postUser,
             .postCSForgotPassword,
             .putCSForgotPassword:
            // JWT not included
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
