//
//  SettingViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

class SettingViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case myInfo
        case setting
    }
    
    enum MyInfoSection: String, CaseIterable {
        case profile
    }
    
    enum SettingSection: CaseIterable {
        case emotion
        case notification
        case license
        case version
    }

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
            API.shared.request(.getUser(uuid: uuid), responseModel: GetUsersResponse.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                case .none:
                    print("result none")
                }
            }
            
            API.shared.request(.getUserProfile(uuid: uuid), responseModel: GetUserProfileResponse.self) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                case .none:
                    print("result none")
                }
            }
        }
    }
    
    // MARK: - Funcs
    func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.setting.rawValue)
        tableView.register(UINib(nibName: "SettingProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Section.myInfo.rawValue)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.allCases[indexPath.section] {
        case .myInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.myInfo.rawValue, for: indexPath)
            switch MyInfoSection.allCases[indexPath.row] {
            case .profile:
                if let cell = cell as? SettingProfileTableViewCell {
                    cell.setData()
                }
            }
            return cell
        case .setting:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.setting.rawValue, for: indexPath)
            switch SettingSection.allCases[indexPath.row] {
            case .notification:
                cell.textLabel?.text = "알림 설정"
            case .emotion:
                cell.textLabel?.text = "감정"
            case .license:
                cell.textLabel?.text = "오픈소스 라이선스"
            case .version:
                cell.textLabel?.text = "최신버전"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.allCases[section] {
        case .myInfo:
            return nil
        case .setting:
            return "Setting"
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .myInfo:
            return MyInfoSection.allCases.count
        case .setting:
            return SettingSection.allCases.count
        }
    }
}
