//
//  MainViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/07.
//

import Foundation
import RxSwift
import RealmSwift

let mainViewModelId = "mainViewModelId"
class MainViewModel: BaseViewModel {
    var id: String = mainViewModelId
    var api: WatsupAPI
    var repository: WatsupRepository
    var selectedDate: BehaviorSubject<Date> = BehaviorSubject(value: Date().startOfDay)
    
    required init(api: WatsupAPI, repository: WatsupRepository) {
        self.api = api
        self.repository = repository
    }
    
    func setDate(selectedDate: Date) {
        self.selectedDate = BehaviorSubject(value: selectedDate.startOfDay)
    }
    
    func getEmotions(userUUID: String) -> Results<Emotion> {
        return repository.getEmotions(uuid: userUUID)
    }
}
