//
//  APIModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation
import Alamofire

enum APIModel: URLRequestConvertible {
    
    case postUsers(_ request: PostUsersRequest?)
    case postAuth(_ request: PostAuthRequest?)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .postUsers(_),
             .postAuth(_):
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .postUsers(_):
            return "/users"
        case .postAuth(_):
            return "/auth"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Codable {
        switch self {
        case .postUsers(let param):
            return param
        case .postAuth(let param):
            return param
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try "http://localhost:8000".asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let json = parameters.asDictionary() {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
