//
//  Container.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/24.
//

import Foundation

protocol BaseViewModel: AnyObject {
    var id: String { get }
    var api: WatsupAPI { get }
    var repository: WatsupRepository { get }
    init(api: WatsupAPI, repository: WatsupRepository)
}

class Container {
    static let shared = Container()
    /// user uuid
    var myUUID: String?
    private init() { }
    var viewModels = [String: BaseViewModel]()
    
    func register<T: BaseViewModel>(_ viewModel: T.Type) {
        let viewModel = viewModel.init(api: API.shared, repository: DatabaseWorker.shared)
        viewModels[viewModel.id] = viewModel
    }
    
    func resolve<T: BaseViewModel>(id: String) -> T {
        return viewModels[id] as! T
    }
    
    func initialize() {
        Container.shared.register(MainViewModel.self)
        Container.shared.register(AuthViewModel.self)
        Container.shared.register(GroupViewModel.self)
        Container.shared.register(SettingViewModel.self)
        Container.shared.myUUID = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    }
    
    func removeAll() {
        myUUID = nil
        viewModels.removeAll()
    }
}
