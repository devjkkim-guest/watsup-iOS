//
//  UserDetailTableHeaderView.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/17.
//

import UIKit

protocol UserDetailTableHeaderViewDelegate: class {
    func didClickEditProfile()
}

class UserDetailTableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var editProfileIconButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: UserDetailTableHeaderViewDelegate?
    
    @IBAction func onClickEditProfile(_ sender: UIButton) {
        delegate?.didClickEditProfile()
    }
}
