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
    
    /** User */
    case getUser(_ request: GetUserRequest)
    case postUser(_ request: PostUsersRequest)
    case getUserProfile(_ request: GetUserProfileRequest)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPasswordRequest)
    case putCSForgotPassword(_ request: PutCSForgotPasswordRequest)
    
    /** Group */
    case postGroups(_ request: PostGroupsRequest)
    case getUserGroup(_ request: GetUserGroupRequest)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getUser,
             .getUserProfile,
             .getUserGroup:
            return .get
        case .postUser,
             .postAuth,
             .postGroups,
             .postCSForgotPassword:
            return .post
        case .putCSForgotPassword:
            return .put
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        /** User */
        case .getUser(let uuid):
            return "/users/\(uuid)"
        case .getUserProfile(let uuid):
            return "/users/\(uuid)/profile"
        case .postUser(_):
            return "/users"
            
        /** Auth */
        case .postAuth(_):
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
        case .putCSForgotPassword(let param):
            return param
        case .postCSForgotPassword(let param):
            return param
        /** Groups */
        case .postGroups(let param):
            return param
        case .getUserGroup:
            return nil
        case .getUser,
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
        case .getUser,
             .getUserProfile,
             .getUserGroup,
             .postGroups:
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
        let baseURrl = "http://dev.team726.com:8000"
        var url: URL?
        if let urlQuery = urlQuery,
           let query = urlQuery.asDictionary()?.map({ "\($0.key)=\($0.value)"}) {
            let queries = query.reduce("?") { $0 + $1 }
            url = try? URLComponents(string: baseURrl.appending("?\(queries)"))?.asURL()
        }else{
            url = URL(string: baseURrl)
        }
        
        if let url = url {
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            
            // HTTP Method
            urlRequest.httpMethod = method.rawValue
            
            // Common Headers
            urlRequest.headers = headers
            
            // Parameters
            if let parameters = parameters, let json = parameters.asDictionary() {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
            
            return urlRequest
        }else{
            var urlRequest = URLRequest(url: url!)
            return urlRequest
            
        }
    }
}
