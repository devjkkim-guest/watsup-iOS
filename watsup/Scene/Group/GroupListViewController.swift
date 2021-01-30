//
//  GroupListViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class GroupListViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case invitedGroup
        case joinedGroup
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GroupInvitedTableViewCell", bundle: nil), forCellReuseIdentifier: Section.invitedGroup.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.joinedGroup.rawValue)
        
        tableView.reloadData()
        API.shared.request(.postGroups, responseModel: PostGroupsResponse.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                print("none")
            }
        }
    }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Section.joinedGroup.rawValue, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            return 10
        }
    }
}
