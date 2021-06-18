//
//  GroupResponses.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/13.
//

import Foundation

struct GetUserInboxResponse: Codable {
    var inbox: [InboxGroupResponse]
}

struct InboxGroupResponse: Codable {
    var groupUuid: String?
    var fromUser: User?
    var name: String?
}
