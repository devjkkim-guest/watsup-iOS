//
//  GroupListViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit
import Alamofire

class GroupListViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case invitedGroup
        case joinedGroup
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    var groups: [GroupResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserGroups()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GroupInvitedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.invitedGroup.rawValue)
        tableView.register(UINib(nibName: "GroupJoinedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.joinedGroup.rawValue)

        tableView.reloadData()
    }
    
    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Group", message: "type name for group", preferredStyle: .alert)
        alertController.addTextField { textField in
            // todo: custom tf
        }

        let actionCreateGroup = UIAlertAction(title: "Create a group", style: .default) { action in
            if let groupName = alertController.textFields?.first?.text {
                let request = PostGroupsRequest(group_name: groupName)
                API.shared.postGroups(request) { result in
                    switch result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

        let actionCreateGroupCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(actionCreateGroup)
        alertController.addAction(actionCreateGroupCancel)

        present(alertController, animated: true, completion: nil)
    }
    
    /// 사용자가 가입된 그룹들 조회
    func getUserGroups() {
        API.shared.getUserGroup { result in
            switch result {
            case .success(let data):
                self.groups = data.groups
                self.tableView.reloadData()
//                    data.groups.forEach { group in
//                        let request = GetGroupRequest(uuid: group.uuid)
//                        self.getGroup(request: request)
//                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// 사용자가 가입한 그룹의 디테일 조회
//    func getGroup(request: GetGroupRequest) {
//        API.shared.getGroup(request) { response in
//            switch response {
//            case .success(let group):
//                self.groups = group
//                self.tableView.reloadData()
//                break
//            case .failure(_): break
//            }
//        }
//    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "초대받은 그룹"
        }else{
            return "참여 중인 그룹"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.allCases[indexPath.section] {
        case .invitedGroup:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Section.invitedGroup.rawValue, for: indexPath) as? GroupInvitedTableViewCell {
                cell.backgroundColor = .clear
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: Section.invitedGroup.rawValue, for: indexPath)
                return cell
            }
        case .joinedGroup:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.joinedGroup.rawValue, for: indexPath) as! GroupJoinedTableViewCell
            cell.configure(name: groups?[indexPath.row].name)
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section.allCases[indexPath.section] {
        case .invitedGroup:
            return 156
        case .joinedGroup:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailVC")
        vc.title = self.groups?[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GroupListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .invitedGroup:
            return 1
        case .joinedGroup:
            return self.groups?.count ?? 0
        }
    }
}
