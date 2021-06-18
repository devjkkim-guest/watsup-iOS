//
//  APIError.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/08.
//

import Foundation
import Alamofire

struct APIError: Error {
    enum ErrorType {
        case httpError
        case jsonError(type: JSONError)
        case others(type: Others)
    }
    
    enum HTTPError: Int {
        case loginFailed = 400
        case userExists = 409
        case notValidEmailAddr = 422
        
        case notDefiend
    }
    
    enum JSONError {
        case decodingError
        case serializeError
        
        case notDefined
    }
    
    enum Others {
        case noErrorCode
        case notDefined
    }
    
    let errorType: ErrorType
    let errorCode: Int
    /// Error Message for Alert UI
    let localizedErrorMessage: String
    
    init(errorType: ErrorType, errorCode: Int) {
        self.errorCode = errorCode
        self.errorType = errorType
        self.localizedErrorMessage = APIError.getLocalizedErrorMessage(errorType: errorType, errorCode: errorCode)
    }
    
    init(jsonError: JSONError) {
        let errorType: ErrorType = .jsonError(type: jsonError)
        let errorCode: Int = -1
        self.errorType = errorType
        self.errorCode = errorCode
        self.localizedErrorMessage = APIError.getLocalizedErrorMessage(errorType: errorType, errorCode: errorCode)
    }
    
    private static func getLocalizedErrorMessage(errorType: ErrorType, errorCode: Int) -> String {
        switch errorType {
        case .httpError:
            switch HTTPError(rawValue: errorCode) {
            case .loginFailed:
                return "API.Error.400".localized
            case .notValidEmailAddr:
                return "API.Error.422".localized
            case .userExists:
                return "API.Error.409".localized
            case .notDefiend:
                return "\("API.Error.NotDefined".localized)\n\(String(describing: errorType)).\(errorCode)"
            case .none:
                return "\("API.Error.NotDefined".localized)\n\(String(describing: errorType)).\(errorCode)"
            }
            
        case .jsonError(let type):
            switch type {
            case .decodingError:
                return "json decoding error."
            case .serializeError:
                return "json serialize error."
                
            case .notDefined:
                return "not defined json error."
            }
            
        case .others(let type):
            switch type {
            case .noErrorCode:
                return "\("API.Error.NotDefined".localized)\n\(String(describing: errorType)).\(errorCode)"
                
            case .notDefined:
                return "\("API.Error.NotDefined".localized)\n\(String(describing: errorType)).\(errorCode)"
            }
        }
    }
}
