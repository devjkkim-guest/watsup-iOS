//
//  API.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation
import Alamofire

class API {
    static var shared: API = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 1
        configuration.waitsForConnectivity = true
        let logger = APIEventMonitor()
        let interceptor = APIInterceptor(storage: APITokenStorage())
        let session = Session(configuration: configuration, interceptor: interceptor, eventMonitors: [logger])
        return API(session: session)
    }()
    private let session: Session
    
    private init(session: Session) {
        self.session = session
    }
    
    func request<T:Decodable>(_ model: APIModel, responseModel: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        session.request(model)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed),
                       let json = try? decoder.decode(T.self, from: jsonData) {
                        completion(.success(json))
                    }else{
                        completion(.failure(.explicitlyCancelled))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
