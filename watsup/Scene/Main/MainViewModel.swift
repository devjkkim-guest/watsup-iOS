//
//  MainViewModel.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/07.
//

import Foundation
import RxSwift

class MainViewModel {
    let selectedDate: BehaviorSubject<Date>
    
    init(selectedDate: Date) {
        self.selectedDate = BehaviorSubject(value: selectedDate)
    }
}
