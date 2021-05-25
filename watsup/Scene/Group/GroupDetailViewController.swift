//
//  GroupDetailViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var btnConfigure: UIBarButtonItem!
    @IBOutlet weak var btnInvite: UIBarButtonItem!
    let viewModel: GroupViewModel = Container.shared.resolve(id: groupViewModelId)
    var group: Group?

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.checkIfIAmMaster(in: group) {
            navigationItem.rightBarButtonItems = [btnInvite, btnConfigure]
        } else {
            navigationItem.rightBarButtonItems = [btnInvite]
        }
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(UINib(nibName: "GroupMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        group?.joinedUsers.forEach({ joinedUser in
            guard let uuid = joinedUser.user?.uuid else { return }
            API.shared.getUserEmotions(uuid: uuid) { result in
                switch result {
                case .success:
                    for cell in self.membersTableView.visibleCells {
                        if let cell = cell as? GroupMemberTableViewCell,
                           cell.uuid == uuid {
                            cell.configure(joinedUser: joinedUser)
                            break
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func onClickInvite(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Invite a Friend", message: "enter friend's email", preferredStyle: .alert)
        alertController.addTextField { textField in
            // todo: custom tf
        }

        let actionCreateGroup = UIAlertAction(title: "Invite", style: .default) { action in
            guard let groupUUID = self.group?.uuid else { return }
            guard let userEmail = alertController.textFields?.first?.text else { return }
            let request = PostGroupInviteRequest(userEmail: userEmail)
            API.shared.postGroupInvite(groupUUID, request) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

        let actionCreateGroupCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(actionCreateGroup)
        alertController.addAction(actionCreateGroupCancel)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickConfigure(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Edit Group Name", message: "enter group's new name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.title
        }

        let actionCreateGroup = UIAlertAction(title: "Confirm", style: .default) { action in
            guard let groupUUID = self.group?.uuid else { return }
            guard let groupName = alertController.textFields?.first?.text else { return }
            let request = PutGroupRequest(groupName: groupName)
            self.viewModel.api.putGroup(groupUUID, request: request) { result in
                switch result {
                case .success:
                    self.title = groupName
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

        let actionCreateGroupCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(actionCreateGroup)
        alertController.addAction(actionCreateGroupCancel)

        present(alertController, animated: true, completion: nil)
    }
}

extension GroupDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = group?.joinedUsers[indexPath.row]
        if let uuid = selectedUser?.user?.uuid {
            API.shared.getUserEmotions(uuid: uuid) { result in
                switch result {
                case .success(let response):
                    if let logs = response.logs {
                        let vc = UserDetailViewController(nibName: "UserDetailViewController", bundle: nil)
                        vc.user = selectedUser?.user
                        vc.emotions = logs.sorted(by: { $0.createdAt < $1.createdAt })
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            showAlert(message: "No User UUID.")
        }
    }
}

extension GroupDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupMemberTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(joinedUser: group?.joinedUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.joinedUsers.count ?? 0
    }
}

extension GroupDetailViewController: GroupMemberTableViewCellDelegate {
    func didClickExpel(_ sender: UIButton) {
        
    }
}
