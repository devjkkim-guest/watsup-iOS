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
        btnProfile.layer.cornerRadius = btnProfile.frame.size.width/2
        btnProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        if let user = DatabaseWorker.shared.getMyProfile()?.first {
            nameLabel.text = user.profile?.nickname
        }
    }
}
