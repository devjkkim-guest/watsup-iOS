//
//  GroupRequests.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/21.
//

import Foundation

struct PutGroupRequest: Codable {
    let groupName: String
}

struct PostGroupInviteRequest: Codable {
    let userEmail: String
}
