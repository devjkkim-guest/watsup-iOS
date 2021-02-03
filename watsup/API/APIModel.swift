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
    case getUser(uuid: String)
    case postUser(_ request: PostUsersRequest)
    case getUserProfile(uuid: String)
    
    /** Customer Service */
    case postCSForgotPassword(_ request: PostCSForgotPassword)
    case putCSForgotPassword(_ request: PutCSForgotPassword)
    
    /** Group */
    case postGroups
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getUser,
             .getUserProfile:
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
        }
    }
    
    // MARK: - Parameters
    private var parameters: Codable? {
        switch self {
        case .postUser(let param):
            return param
        case .postAuth(let param):
            return param
        case .putCSForgotPassword(let param):
            return param
        case .postCSForgotPassword(let param):
            return param
        case .getUser,
             .getUserProfile,
             .postGroups:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        var commonHeaders: HTTPHeaders = [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                                          HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue]
        switch self {
        case .getUser,
             .getUserProfile:
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
        let url = try "http://dev.team726.com:8000".asURL()
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
    }
}
