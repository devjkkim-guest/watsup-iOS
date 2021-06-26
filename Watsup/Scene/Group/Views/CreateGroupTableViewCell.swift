//
//  CreateGroupTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/13.
//

import UIKit

protocol CreateGroupTableViewCellDelegate: AnyObject {
    func didClickCreateGroup()
}

class CreateGroupTableViewCell: UITableViewCell {
    weak var delegate: CreateGroupTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickCreateGroup(_ sender: UIButton) {
        delegate?.didClickCreateGroup()
    }
}
