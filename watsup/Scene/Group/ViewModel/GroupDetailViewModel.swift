//
//  GroupDetailViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/25.
//

import Foundation

public let groupDetailViewModelId = "groupDetailViewModelId"

class GroupDetailViewModel: BaseViewModel {
    var id: String = groupDetailViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
}
