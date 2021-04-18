//
//  GroupDetailViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    @IBOutlet weak var membersTableView: UITableView!
    var group: Group?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(UINib(nibName: "GroupMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension GroupDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = group?.joinedUsers?[indexPath.row]
        if let uuid = selectedUser?.uuid {
            API.shared.getUserEmotions(uuid: uuid) { result in
                switch result {
                case .success(let response):
                    if let logs = response.logs {
                        let vc = UserDetailViewController(nibName: "UserDetailViewController", bundle: nil)
                        vc.user = selectedUser
                        vc.emotions = logs
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension GroupDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupMemberTableViewCell
        cell.delegate = self
        let user = group?.joinedUsers?[indexPath.row]
        let emotion = DatabaseWorker.shared.getEmotionList()
        cell.configure(user: user, emotion: emotion.first)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.joinedUsers?.count ?? 0
    }
}

extension GroupDetailViewController: GroupMemberTableViewCellDelegate {
    func didClickExpel(_ sender: UIButton) {
        
    }
}
