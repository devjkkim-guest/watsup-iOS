//
//  UserDetailViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit
import MobileCoreServices

class UserDetailViewController: UIViewController {

    let emotionCell = "emotionCell"
    @IBOutlet weak var tableView: UITableView!
    
    var emotions: [Emotion]?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user?.profile?.nickname
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserDetailEmotionTableViewCell", bundle: nil), forCellReuseIdentifier: emotionCell)
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "UserDetailTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UserDetailTableHeaderView
        headerView?.nameLabel.text = user?.profile?.nickname
        headerView?.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: emotionCell, for: indexPath) as! UserDetailEmotionTableViewCell
        cell.configure(emotion: emotions?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UserDetailViewController: UserDetailTableHeaderViewDelegate {
    func didClickEditProfile() {
        requestPhotoAccess(delegate: self)
    }
}

extension UserDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        picker.dismiss(animated: true) {
            let mediaType = info[.mediaType] as! CFString
            switch mediaType {
            case kUTTypeImage:
                print("image")
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
