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
    
    enum MyInfoRow: String, CaseIterable {
        case profile
    }
    
    enum SettingRow: CaseIterable {
        case emotion
        case notification
        case license
        case version
        case leave
    }

    @IBOutlet weak var tableView: UITableView!
    let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue)
    let viewModel: SettingViewModel = Container.shared.resolve(id: settingViewModelId)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
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
    
    func showConfirmLeaveAlert() {
        let message = "Leave.Confirm".localized
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionLeave = UIAlertAction(title: "Leave", style: .default) { [weak self] _ in
            self?.viewModel.deleteUser { result in
                switch result {
                case .success:
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.logout()
                    }
                case .failure(let error):
                    self?.showAlert(apiError: error)
                }
            }
        }
        let actionCancle = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionLeave)
        alert.addAction(actionCancle)
        present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.allCases[indexPath.section] {
        case .myInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.myInfo.rawValue, for: indexPath) as! SettingProfileTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case .setting:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.setting.rawValue, for: indexPath)
            cell.selectionStyle = .none
            
            switch SettingRow.allCases[indexPath.row] {
            case .notification:
                cell.textLabel?.text = "알림 설정"
            case .emotion:
                cell.textLabel?.text = "감정"
            case .license:
                cell.textLabel?.text = "오픈소스 라이선스"
            case .version:
                cell.textLabel?.text = "최신버전"
            case .leave:
                cell.textLabel?.text = "탈퇴하기"
                cell.textLabel?.textColor = .red
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
            break
        case .setting:
            switch SettingRow.allCases[indexPath.row] {
            case .leave:
                showConfirmLeaveAlert()
            default:
                break
            }
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
            return MyInfoRow.allCases.count
        case .setting:
            return SettingRow.allCases.count
        }
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let mediaType = info[.mediaType] as! CFString
            switch mediaType {
            case kUTTypeImage:
                guard let uuid = self.uuid else { break }
                if let image = info[.originalImage] as? UIImage {
                WUProgress.show()
                    self.viewModel.putUserProfileImage(uuid, image: image) { result in
                        WUProgress.dismiss()
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

extension SettingViewController: SettingProfileTableViewCellDelegate {
    func didClickUpdateProfileImage() {
        requestPhotoAccess(delegate: self)
    }
    
    func reloadTableData() {
        tableView.reloadData()
    }
}
