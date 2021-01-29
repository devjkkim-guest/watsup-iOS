//
//  APIInterceptor.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import Foundation
import Alamofire

protocol TokenStorage {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

class APIInterceptor: RequestInterceptor {
    public let storage: TokenStorage
    
    init(storage: TokenStorage) {
        self.storage = storage
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let statusCode = request.response?.statusCode {
            if statusCode == 401 {
                print("refresh!")
            }
        }
    }
}
