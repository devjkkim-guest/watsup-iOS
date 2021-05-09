//
//  SettingViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit
import MobileCoreServices
import Alamofire

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
    let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
            API.shared.getUser(uuid) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            API.shared.getUserProfile(uuid) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
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
                    cell.configure(profileImage: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .myInfo:
            requestPhotoAccess(delegate: self)
            break
        default:
            break
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

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let mediaType = info[.mediaType] as! CFString
            switch mediaType {
            case kUTTypeImage:
                if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.8),
                   let uuid = self.uuid {
                    let request = PutUserProfileImageRequest(image: data)
                    API.shared.putUserProfileImage(uuid, request: request) { result in
                        switch result {
                        case .success(let response):
                            print(response.result ?? false)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case kUTTypeMovie:
                print("video")
            default:
                break
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
