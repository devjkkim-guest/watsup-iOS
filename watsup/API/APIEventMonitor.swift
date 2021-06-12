//
//  APIEventMonitor.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/28.
//

import Foundation
import Alamofire

class APIEventMonitor: EventMonitor {
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        log(request: request, function: #function)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🙋‍♂️ Response\n\(response.debugDescription)")
    }
    
    func log(request: Request, function: String) {
        let header = request.request.flatMap { $0.allHTTPHeaderFields } ?? ["None": "None"]
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        \(function)
        ⚡️ Request Started: \(request)
        ⚡️ Header Data: \(header)
        ⚡️ Body Data: \(body)
        """
        print(message)
    }
}
