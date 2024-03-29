//
//  APIConstants.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/27.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
    case imageJpeg = "image/jpeg"
}

struct MimeType {
    enum Image: String {
        case jpeg
        case png
    }
}
