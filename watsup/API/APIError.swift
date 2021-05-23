//
//  APIError.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/08.
//

import Foundation
import Alamofire

struct APIError: Error {
    enum APIErrorCode: Int {
        case loginFailed = 400
        case notValidEmailAddr = 422
        case defaultError
    }
    
    let errorMsg: String
    let errorCode: APIErrorCode
    
    init(errorCode: APIErrorCode? = nil) {
        if let errorCode = errorCode {
            self.errorCode = errorCode
            self.errorMsg = APIError.getErrorMessage(for: errorCode)
        }else{
            self.errorCode = .defaultError
            self.errorMsg = APIError.getErrorMessage(for: .defaultError)
        }
    }
    
    static func getErrorMessage(for errorCode: APIErrorCode) -> String {
        switch errorCode {
        case .loginFailed:
            return "API.Auth.Error.400".localized
        case .notValidEmailAddr:
            return "API.Auth.Error.422".localized
        default:
            return "API.Common.Error.DefaultMessage".localized
        }
    }
}
