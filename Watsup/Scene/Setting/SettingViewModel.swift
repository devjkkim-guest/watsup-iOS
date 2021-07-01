//
//  SettingViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/26.
//

import UIKit
import RxSwift
import RealmSwift
import Alamofire

let settingViewModelId = "settingViewModelId"

class SettingViewModel: BaseViewModel {
    var id: String = settingViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    lazy var myInfo = repository.getMyProfile()
    let profileImage = BehaviorSubject(value: UIImage(systemName: "person"))
    let disposeBag = DisposeBag()
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func getMyProfileImage() {
        guard let user = myInfo?.first else { return }
        api.getUserProfileImage(user) { [weak self] result in
            switch result {
            case .success(let image):
                self?.profileImage.onNext(image)
            case .failure:
                break
            }
        }
    }
    
    func putUserProfileImage(_ uuid: String, image: UIImage, completion: @escaping (Result<UserProfileResponse, APIError>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            let error = APIError(errorType: .insufficientRequest, errorCode: -1)
            completion(.failure(error))
            return
        }
        let request = PutUserProfileImageRequest(image: data)
        api.putUserProfileImage(uuid, request: request, completion: { [weak self] result in
            guard let self = self else {
                completion(.failure(APIError(errorType: .others(type: .notDefined), errorCode: -1)))
                return
            }
            switch result {
            case .success(let response):
                if let user = self.repository.getUser(uuid).first {
                    self.repository.updateUser(user: user, response: response)
                }
                self.getMyProfileImage()
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
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
