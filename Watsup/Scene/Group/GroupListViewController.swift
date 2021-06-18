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
        
        func getIntValue() -> Int {
            switch self {
            case .invitedGroup:
                return 0
            case .joinedGroup:
                return 1
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    let createGroupCellId = "CreateGroupCell"
    var invitedGroups: [InboxGroupResponse]?
    var joinedGroups: Results<Group>?
    var groupNotificationToken: NotificationToken?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        joinedGroups = DatabaseWorker.shared.getGroups()
        requestAPI()
        setTableView()
        bindModel()
    }
    
    // MARK: - Initial Set
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GroupInvitedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.invitedGroup.rawValue)
        tableView.register(UINib(nibName: "GroupJoinedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.joinedGroup.rawValue)
        tableView.register(UINib(nibName: "CreateGroupTableViewCell", bundle: nil), forCellReuseIdentifier: createGroupCellId)
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(requestAPI), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    func bindModel() {
        let groups = DatabaseWorker.shared.getGroups()
        groupNotificationToken = groups.observe { change in
            switch change {
            case .update:
                self.tableView.reloadSections([Section.joinedGroup.getIntValue()], with: .automatic)
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
                let request = PostGroupsRequest(groupName: groupName)
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
    
    func hasJoinedGroups() -> Bool {
        if let joined = joinedGroups, joined.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    // MARK: - API
    @objc func requestAPI() {
        let dispatchGroup = DispatchGroup()
        getInvitedGroups(dispatchGroup)
        getUserGroups(dispatchGroup)
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // 사용자가 초대받은 그룹들 조회
    func getInvitedGroups(_ dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        API.shared.getUserInbox { result in
            switch result {
            case .success(let response):
                self.invitedGroups = response.inbox
            case .failure(let error):
                self.showAlert(apiError: error)
            }
            dispatchGroup?.leave()
        }
    }
    
    /// 사용자가 가입된 그룹들 조회
    func getUserGroups(_ dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        API.shared.getUserGroup { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup?.leave()
        }
    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.allCases[section] {
        case .invitedGroup:
            return "초대받은 그룹"
        case .joinedGroup:
            return "참여중인 그룹"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.allCases[indexPath.section] {
        case .invitedGroup:
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.invitedGroup.rawValue, for: indexPath) as! GroupInvitedTableViewCell
            cell.invitedGroups = invitedGroups
            cell.delegate = self
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case .joinedGroup:
            if hasJoinedGroups() {
                let cell = tableView.dequeueReusableCell(withIdentifier: Section.joinedGroup.rawValue, for: indexPath) as! GroupJoinedTableViewCell
                cell.configure(name: joinedGroups?[indexPath.row].name)
                cell.textLabel?.sizeToFit()
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: createGroupCellId, for: indexPath) as! CreateGroupTableViewCell
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section.allCases[indexPath.section] {
        case .invitedGroup:
            if let groups = invitedGroups, !groups.isEmpty {
                return 156
            } else {
                return 0
            }
        case .joinedGroup:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let joinedGroups = joinedGroups, joinedGroups.count != 0 else { return }
        if let uuid = joinedGroups[indexPath.row].uuid {
            API.shared.getGroup(uuid) { result in
                switch result {
                case .success(let group):
                    let vc = UIStoryboard(name: "Group", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailVC") as! GroupDetailViewController
                    vc.title = joinedGroups[indexPath.row].name
                    vc.viewModel.setGroup(group)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let group = joinedGroups?[indexPath.row], let uuid = group.uuid {
            let action = UIContextualAction(style: .destructive, title: "Leave") { (action, view, handler) in
                let alertController = UIAlertController(title: nil, message: "Are you sure to Leave?", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "Leave", style: .destructive) { _ in
                    API.shared.getGroupLeave(uuid) { result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            self.showAlert(message: error.localizedErrorMessage)
                        }
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
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .invitedGroup:
            if let invited = invitedGroups, !invited.isEmpty {
                return 1
            } else {
                return 0
            }
        case .joinedGroup:
            if let groups = joinedGroups, !groups.isEmpty {
                return groups.count
            }else{
                // 가입된 그룹이 없을 때 보여줄 셀
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section.allCases[section] {
        case .invitedGroup:
            if let invited = invitedGroups, !invited.isEmpty {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        case .joinedGroup:
            return UITableView.automaticDimension
        }
    }
}

extension GroupListViewController: CreateGroupTableViewCellDelegate {
    func didClickCreateGroup() {
        showCreateNewGroupAlert()
    }
}

extension GroupListViewController: GroupInvitedCollectionViewCellDelegate {
    func onClickJoin(groupUUID: String) {
        API.shared.getGroupJoin(groupUUID) { result in
            switch result {
            case .success(let group):
                self.invitedGroups?.removeAll(where: { invitedGroup in
                    return invitedGroup.groupUuid == group.uuid
                })
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
