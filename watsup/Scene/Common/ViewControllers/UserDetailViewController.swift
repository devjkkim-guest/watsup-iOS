//
//  UserDetailViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var emotions: [Emotion]?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user?.profile?.nickname
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "UserDetailTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UserDetailTableHeaderView
        headerView?.nameLabel.text = user?.profile?.nickname
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = emotions?[indexPath.row].message
        return cell
    }
}
