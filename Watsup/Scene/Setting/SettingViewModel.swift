//
//  SettingViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/26.
//

import Foundation

let settingViewModelId = "settingViewModelId"

class SettingViewModel: BaseViewModel {
    var id: String = settingViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func deleteUser(completion: @escaping (Result<CommonResponse, APIError>) -> Void) {
        api.deleteUser { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
