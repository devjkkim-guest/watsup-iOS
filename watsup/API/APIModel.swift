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
    case getUserEmotions(_ request: GetUserEmotionsRequest)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPasswordRequest)
    case putCSForgotPassword(_ request: PutCSForgotPasswordRequest)
    
    /** Group */
    case getGroup(_ request: GetGroupRequest)
    case postGroups(_ request: PostGroupsRequest)
    case getUserGroup(_ request: GetUserGroupRequest)
    
    static let baseUrl = "http://dev.team726.com:8000"
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .putAuth:
            return .put
        default:
            break
        }

        if parameters == nil {
            return .get
        }else{
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        /** User */
        case .getUser(let uuid):
            return "/users/\(uuid.uuid)"
        case .getUserProfile(let uuid):
            return "/users/\(uuid)/profile"
        case .postUser(_):
            return "/users"
        case .getUserEmotions(let req):
            return "/users/\(req.user_uuid)/emotions"
            
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
        case .getUserGroup(let group):
            return "/users/\(group.user_uuid)/groups"
        case .getGroup(let group):
            return "/groups/\(group.uuid)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Codable? {
        switch self {
        /** Users */
        case .postUser(let param):
            return param
        case .postAuth(let param):
            return param
        case .putAuth:
            return nil
        case .putCSForgotPassword(let param):
            return param
        case .postCSForgotPassword(let param):
            return param
        case .getUserEmotions:
            return nil
            
        /** Groups */
        case .postGroups(let param):
            return param
        case .getUserGroup,
             .getGroup,
             .getUser,
             .getUserProfile:
            return nil
        }
    }
    
    private var urlQuery: Codable? {
        switch self {
        case .getUserGroup(let param):
            return param
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
             .getUserEmotions:
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
        var urlString = APIModel.baseUrl.appending(path)
        
        if let urlQuery = urlQuery,
           let query = urlQuery.asDictionary()?.map({ "\($0.key)=\($0.value)"}) {
            let queries = query.reduce("?") { $0 + $1 }
            urlString = urlString.appending(queries)
        }
        
        var urlRequest = URLRequest(url: try urlString.asURL())
        urlRequest.headers = headers
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters, let json = parameters.asDictionary() {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
