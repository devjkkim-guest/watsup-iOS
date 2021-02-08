//
//  APIError.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/08.
//

import Foundation
import Alamofire

struct APIError: Error {
    let errorMsg: String = ""
    let errorCode: Int = 0
}
