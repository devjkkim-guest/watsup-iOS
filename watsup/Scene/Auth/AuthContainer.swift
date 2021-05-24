//
//  AuthContainer.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/24.
//

import Foundation

class AuthContainer {
    static let shared = AuthContainer()
    private init() { }
    let authViewModel = AuthViewModel(api: API.shared, repository: DatabaseWorker.shared)
}
