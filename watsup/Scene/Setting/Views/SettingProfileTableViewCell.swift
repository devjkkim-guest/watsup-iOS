//
//  SettingProfileTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

class SettingProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data: GetUserProfileResponse? = nil) {
        nameLabel.text = "닉네임"
    }
}
