//
//  GetGroupsResponse.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/08.
//

import Foundation

struct GetGroupsResponse: Codable {
    let joinedUsers: [Identity]
    let name: String
    let uuid: String
}
