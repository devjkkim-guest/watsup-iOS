//
//  Container.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/05/24.
//

import Foundation

protocol BaseViewModel {
    var id: String { get }
    var api: WatsupAPI { get }
    var repository: WatsupRepository { get }
    init(api: WatsupAPI, repository: WatsupRepository)
}

class Container {
    static let shared = Container()
    /// user uuid
    var uuid: String?
    private init() { }
    var viewModels = [String: BaseViewModel]()
    
    func register<T: BaseViewModel>(_ viewModel: T.Type) {
        let viewModel = viewModel.init(api: API.shared, repository: DatabaseWorker.shared)
        viewModels[viewModel.id] = viewModel
    }
    
    func resolve<T: BaseViewModel>(id: String) -> T {
        return viewModels[id] as! T
    }
}
