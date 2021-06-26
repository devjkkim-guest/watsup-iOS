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
    func removeAllTokens()
}

class APIInterceptor: RequestInterceptor {
    private let storage: TokenStorage
    /// limit max retry
    private let maxRetry = 1
    
    init(storage: TokenStorage) {
        self.storage = storage
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < maxRetry, let statusCode = request.response?.statusCode {
            let url = request.request?.url
            let method = request.request?.method
            let putAuthReq = APIModel.putAuth.urlRequest
            if statusCode == 401,
               url != putAuthReq?.url && method != putAuthReq?.method {
                // prevent retry by same request
                API.shared.putAuth { response in
                    switch response {
                    case .success(let data):
                        UserDefaults.standard.setValue(data.accessToken, forKey: KeychainKey.accessToken.rawValue)
                        UserDefaults.standard.setValue(data.refreshToken, forKey: KeychainKey.refreshToken.rawValue)
                        // refresh succeeded, retry.
                        self.logAPI(request: request)
                        completion(.retry)
                    case .failure(_):
                        completion(.doNotRetry)
                        break
                    }
                }
            }else{
                logAPI(request: request)
                completion(.retry)
            }
        }else{
            completion(.doNotRetry)
        }
    }
    
    func removeAllTokens() {
        storage.removeAllTokens()
    }
}

extension APIInterceptor {
    func logAPI(request: Request) {
        let header = request.request.flatMap { $0.allHTTPHeaderFields } ?? ["None": "None"]
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Retry \(request.retryCount) Request Started: \(request)
        ⚡️ Header Data: \(header)
        ⚡️ Body Data: \(body)
        """
        print(message)
    }
}
