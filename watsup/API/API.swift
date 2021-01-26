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
        let session = Session()
        return API(session: session)
    }()
    private let session: Session
    
    private init(session: Session) {
        self.session = session
    }
    
    func postUsers(_ request: APIModel, completion: @escaping (Result<Data, AFError>) -> Void) {
        session.request(request)
            .validate()
            .responseData { data in
                completion(data.result)
            }
    }
}
