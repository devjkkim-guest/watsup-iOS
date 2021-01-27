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
        let session = Session(configuration: configuration, eventMonitors: [logger])
        return API(session: session)
    }()
    private let session: Session
    
    private init(session: Session) {
        self.session = session
    }
    
    func postAuth(_ request: APIModel, completion: @escaping (Result<PostUsersResponse, AFError>?) -> Void) {
        session.request(request)
            .validate()
            .responseJSON { response in
                if let data = response.data,
                   let json = try? JSONDecoder().decode(PostUsersResponse.self, from: data) {
                    completion(.success(json))
                }else{
                    if let error = response.error {
                        completion(.failure(error))
                    }else{
                        completion(nil)
                    }
                }
            }
    }
    
    func postUsers(_ request: APIModel, completion: @escaping (Result<PostUsersResponse, AFError>?) -> Void) {
        session.request(request)
            .validate()
            .responseJSON { response in
                if let data = response.data,
                   let json = try? JSONDecoder().decode(PostUsersResponse.self, from: data) {
                    completion(.success(json))
                }else{
                    if let error = response.error {
                        completion(.failure(error))
                    }else{
                        completion(nil)
                    }
                }
            }
    }
}
