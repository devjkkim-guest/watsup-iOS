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
    case getUserProfileImage(_ uuid: String)
    case putUserProfile(_ uuid: String, request: PutUserProfileRequest)
    case putUserProfileImage(_ uuid: String, request: PutUserProfileImageRequest)
    case getUserEmotions(_ uuid: String)
    case postEmotion(_ request: PostEmotionRequest)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPasswordRequest)
    case putCSForgotPassword(_ request: PutCSForgotPasswordRequest)
    
    /** Group */
    case getGroup(_ groupUUID: String)
    case putGroups(_ groupUUID: String, _ request: PutGroupRequest)
    case getGroupLeave(_ groupUUID: String)
    case postGroups(_ request: PostGroupsRequest)
    case postGroupInvite(_ groupUUID: String, _ request: PostGroupInviteRequest)
    case getUserGroup
    case getGroupJoin(_ groupUUID: String)
    case getUserInbox
    case deleteGroups(_ groupUUID: String)
    
    static let baseUrl = "http://dev.team726.com:8000"
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getUser,
             .getUserProfile,
             .getUserProfileImage,
             .getUserEmotions,
             .getGroup,
             .getGroupLeave,
             .getGroupJoin,
             .getUserGroup,
             .getUserInbox:
            return .get
        case .putUserProfile,
             .putAuth,
             .putCSForgotPassword,
             .putGroups,
             .putUserProfileImage:
            return .put
        case .postEmotion,
             .postAuth,
             .postUser,
             .postGroups,
             .postGroupInvite,
             .postCSForgotPassword:
            return .post
        case .deleteGroups:
            return .delete
        }
    }
    
    var myUUID: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) ?? ""
    }
    
    var image: Data? {
        switch self {
        case .putUserProfileImage(_, let req):
            return req.image
        default:
            return nil
        }
    }
    
    // MARK: - Path
    private var path: String? {
        switch self {
        /** User */
        case .getUser(let uuid):
            return "/users/\(uuid)"
        case .getUserProfile(let uuid):
            return "/users/\(uuid)/profile"
        case .getUserProfileImage(let uuid):
            return "/users/\(uuid)/profile/image"
        case .postUser:
            return "/users"
        case .putUserProfile(let uuid, _):
            return "/users/\(uuid)/profile"
        case .putUserProfileImage(let uuid, _):
            return "/users/\(uuid)/profile/image"
        case .getUserEmotions(let uuid):
            return "/users/\(uuid)/emotions"
        case .postEmotion:
            return "/users/\(myUUID)/emotions"
            
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
        case .putGroups(let groupUUID, _):
            return "/groups/\(groupUUID)"
        case .postGroups:
            return "/groups"
        case .getUserGroup:
            return "/users/\(myUUID)/groups"
        case .getGroupLeave(let groupUUID):
            return "/groups/\(groupUUID)/leave"
        case .deleteGroups(let uuid):
            return "/groups/\(uuid)"
        case .getGroup(let uuid):
            return "/groups/\(uuid)"
        case .getGroupJoin(let groupUUID):
            return "/groups/\(groupUUID)/join"
        case .getUserInbox:
            return "/users/\(myUUID)/inbox"
        case .postGroupInvite(let groupUUID, _):
            return "/groups/\(groupUUID)/invite"
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
        case .putUserProfile(_, let param):
            return encode(parameter: param)
        case .putCSForgotPassword(let param):
            return encode(parameter: param)
        case .postCSForgotPassword(let param):
            return encode(parameter: param)
        case .postEmotion(let param):
            return encode(parameter: param)
        case .putAuth,
             .putUserProfileImage,
             .getUser,
             .getUserEmotions,
             .getUserProfile,
             .getUserProfileImage,
             .getUserInbox:
            return nil
            
        /** Groups */
        case .putGroups(_, let param):
            return encode(parameter: param)
        case .postGroups(let param):
            return encode(parameter: param)
        case .postGroupInvite(_, let param):
            return encode(parameter: param)
        case .getUserGroup,
             .getGroup,
             .getGroupLeave,
             .getGroupJoin,
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
        var customHeaders: HTTPHeaders = [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                                          HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue]
        switch self {
        case .getUser,
             .getUserProfile,
             .putUserProfile,
             .getUserGroup,
             .postGroups,
             .postGroupInvite,
             .getGroupJoin,
             .getGroup,
             .putGroups,
             .getGroupLeave,
             .getUserEmotions,
             .postEmotion,
             .getUserInbox,
             .deleteGroups:
            if let accessToken = UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue) {
                let value = "Bearer \(accessToken)"
                customHeaders.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            // JWT included
            return customHeaders
            
        case .postAuth,
             .postUser,
             .postCSForgotPassword,
             .putCSForgotPassword,
             .getUserProfileImage:
            // default (JWT not included)
            return customHeaders
            
        case .putAuth:
            // refreshToken
            if let refreshToken = UserDefaults.standard.string(forKey: KeychainKey.refreshToken.rawValue) {
                let value = "Bearer \(refreshToken)"
                customHeaders.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            return customHeaders
            
        case .putUserProfileImage:
            // multipart formData
            var multipartHeader: HTTPHeaders = [HTTPHeaderField.contentType.rawValue: ContentType.multipartFormData.rawValue,
                                              HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue]
            if let accessToken = UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue) {
                let value = "Bearer \(accessToken)"
                multipartHeader.add(name: HTTPHeaderField.authentication.rawValue, value: value)
            }
            return multipartHeader
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
