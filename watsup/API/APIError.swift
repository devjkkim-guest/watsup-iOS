//
//  APIError.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/08.
//

import Foundation
import Alamofire

struct APIError: Error {
    let errorMsg: String
    let errorCode: Int
    
    init(errorCode: Int? = nil) {
        if let errorCode = errorCode {
            self.errorCode = errorCode
            self.errorMsg = APIError.getErrorMessage(for: errorCode)
        }else{
            self.errorCode = 0
            self.errorMsg = APIError.getErrorMessage()
        }
    }
    
    static func getErrorMessage(for errorCode: Int? = nil) -> String {
        switch errorCode {
        case 400:
            return "API.Auth.Error.400".localized
        case 422:
            return "API.Auth.Error.422".localized
        default:
            return "API.Common.Error.DefaultMessage".localized
        }
    }
}
