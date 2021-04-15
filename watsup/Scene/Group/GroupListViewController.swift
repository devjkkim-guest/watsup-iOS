//
//  GroupListViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit
import Alamofire
import RealmSwift
import RxSwift

class GroupListViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        /// 초대받은 그룹
        case invitedGroup
        /// 가입된 그룹
        case joinedGroup
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    let createGroupCellId = "CreateGroupCell"
    var invitedGroups: [InboxGroupResponse]?
    var joinedGroups: [Group]?
    var groupNotificationToken: NotificationToken?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        joinedGroups = Array(DatabaseWorker.shared.getGroups())
        getInvitedGroups()
        getUserGroups()
        setTableView()
    }
    
    // MARK: - Initial Set
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GroupInvitedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.invitedGroup.rawValue)
        tableView.register(UINib(nibName: "GroupJoinedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.joinedGroup.rawValue)
        tableView.register(UINib(nibName: "CreateGroupTableViewCell", bundle: nil), forCellReuseIdentifier: createGroupCellId)
    }
    
    func bindModel() {
        let groups = DatabaseWorker.shared.getGroups()
        groupNotificationToken = groups.observe { change in
            switch change {
            case .update(let results, deletions: _, insertions: _, modifications: _):
                self.joinedGroups = Array(results)
                self.tableView.reloadData()
            case .initial, .error:
                break
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        showCreateNewGroupAlert()
    }
    
    func showCreateNewGroupAlert() {
        let alertController = UIAlertController(title: "Create New Group", message: "type name for group", preferredStyle: .alert)
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
    
    // 사용자가 초대받은 그룹들 조회
    func getInvitedGroups() {
        API.shared.getUserInbox { result in
            switch result {
            case .success(let response):
                self.invitedGroups = response.inbox
                self.tableView.reloadData()
            case .failure(let error):
                print(error.errorMsg, error.localizedDescription)
            }
        }
    }
    
    /// 사용자가 가입된 그룹들 조회
    func getUserGroups() {
        API.shared.getUserGroup { result in
            switch result {
            case .success(let data):
                self.joinedGroups = data.groups
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func willShowInvitedGroup() -> Bool {
        if let invited = invitedGroups, invited.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    func willShowJoinedGroups() -> Bool {
        if let joined = joinedGroups, joined.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    func getNumberOfJoinedGroupRows() -> Int {
        if let groups = joinedGroups, groups.count != 0 {
            return groups.count
        }else{
            // 가입된 그룹이 없을 때 보여줄 셀
            return 1
        }
    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if willShowInvitedGroup() {
            switch Section.allCases[section] {
            case .invitedGroup:
                return "초대받은 그룹"
            case .joinedGroup:
                return "참여중인 그룹"
            }
        }else{
            return "참여중인 그룹"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if willShowInvitedGroup() {
            switch Section.allCases[indexPath.section] {
            case .invitedGroup:
                let cell = tableView.dequeueReusableCell(withIdentifier: Section.invitedGroup.rawValue, for: indexPath) as! GroupInvitedTableViewCell
                cell.backgroundColor = .clear
                return cell
            case .joinedGroup:
                if willShowJoinedGroups() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Section.joinedGroup.rawValue, for: indexPath) as! GroupJoinedTableViewCell
                    cell.configure(name: joinedGroups?[indexPath.row].name)
                    cell.textLabel?.sizeToFit()
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: createGroupCellId, for: indexPath) as! CreateGroupTableViewCell
                    cell.delegate = self
                    return cell
                }
            }
        }else{
            if willShowJoinedGroups() {
                let cell = tableView.dequeueReusableCell(withIdentifier: Section.joinedGroup.rawValue, for: indexPath) as! GroupJoinedTableViewCell
                cell.configure(name: joinedGroups?[indexPath.row].name)
                cell.textLabel?.sizeToFit()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: createGroupCellId, for: indexPath) as! CreateGroupTableViewCell
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if willShowInvitedGroup() {
            switch Section.allCases[indexPath.section] {
            case .invitedGroup:
                return 156
            case .joinedGroup:
                return UITableView.automaticDimension
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailVC")
        vc.title = self.joinedGroups?[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let group = joinedGroups?[indexPath.row], let uuid = group.uuid {
            let action = UIContextualAction(style: .destructive, title: "Leave") { (action, view, handler) in
                let alertController = UIAlertController(title: nil, message: "Are you sure to Leave?", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "Leave", style: .destructive) { _ in
                    API.shared.deleteGroups(uuid) { result in
                        self.joinedGroups = Array(DatabaseWorker.shared.getGroups())
                        self.tableView.reloadData()
                    }
                }
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(actionOK)
                alertController.addAction(actionCancel)
                self.present(alertController, animated: true, completion: nil)
            }
            
            return UISwipeActionsConfiguration(actions: [action])
        }else{
            return nil
        }
    }
}

extension GroupListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let invited = invitedGroups, invited.count != 0 {
            return Section.allCases.count
        }else{
            return Section.allCases.count-1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let invited = invitedGroups, invited.count != 0 {
            switch Section.allCases[section] {
            case .invitedGroup:
                return 1
            case .joinedGroup:
                return getNumberOfJoinedGroupRows()
            }
        }else{
            return getNumberOfJoinedGroupRows()
        }
    }
}

extension GroupListViewController: CreateGroupTableViewCellDelegate {
    func didClickCreateGroup() {
        showCreateNewGroupAlert()
    }
}
