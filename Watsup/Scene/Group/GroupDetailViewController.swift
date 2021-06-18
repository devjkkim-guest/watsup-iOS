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

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.checkIfIAmMaster() {
            navigationItem.rightBarButtonItems = [btnInvite, btnConfigure]
        } else {
            navigationItem.rightBarButtonItems = [btnInvite]
        }
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(UINib(nibName: "GroupMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        bindModel()
    }
    
    private func bindModel() {
        _ = viewModel.getJoinedUsers()?.observe({ changes in
            switch changes {
            case .initial:
                self.membersTableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.membersTableView.beginUpdates()
                self.membersTableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0)}, with: .automatic)
                self.membersTableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0)}, with: .automatic)
                self.membersTableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0)}, with: .automatic)
                self.membersTableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @IBAction func onClickInvite(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Invite a Friend", message: "enter friend's email", preferredStyle: .alert)
        alertController.addTextField { textField in
            // todo: custom tf
        }

        let actionInvite = UIAlertAction(title: "Invite", style: .default) { action in
            guard let email = alertController.textFields?.first?.text else { return }
            self.viewModel.inviteUser(email: email)
        }
        let actionCreateGroupCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(actionInvite)
        alertController.addAction(actionCreateGroupCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickConfigure(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Edit Group Name", message: "enter group's new name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.title
        }

        let actionCreateGroup = UIAlertAction(title: "Confirm", style: .default) { action in
            guard let groupName = alertController.textFields?.first?.text else { return }
            self.viewModel.configureGroup(name: groupName) { result in
                switch result {
                case .success(let data):
                    if data.result == true {
                        self.title = groupName
                    }
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
        let selectedUser = viewModel.group?.joinedUsers[indexPath.row]
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
        let joinedUser = viewModel.group?.joinedUsers[indexPath.row]
        if let userUUID = joinedUser?.user?.uuid {
            let lastEmotion = viewModel.getEmotions(userUUID: userUUID).last
            cell.configure(joinedUser: joinedUser, emotion: lastEmotion)
        } else {
            cell.configure(joinedUser: joinedUser, emotion: nil)
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.group?.joinedUsers.count ?? 0
    }
}

extension GroupDetailViewController: GroupMemberTableViewCellDelegate {
    func didClickExpel(_ sender: UIButton) {
        
    }
}
