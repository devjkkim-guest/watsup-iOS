//
//  SettingProfileTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit
import Kingfisher

class SettingProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
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
            emailLabel.text = user.email
            
            if let uuid = user.uuid {
                let model = APIModel.getUserProfileImage(uuid)
                let modifier = AnyModifier { request in
                    var r = request
                    if let accessToken = UserDefaults.standard.string(forKey: KeychainKey.accessToken.rawValue) {
                        let value = "Bearer \(accessToken)"
                        r.setValue(value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
                    }

                    return r
                }
                btnProfile.kf.setImage(with: model.urlRequest?.url, for: .normal, options: [.requestModifier(modifier)])
            } else {
                btnProfile.setImage(UIImage(systemName: "person"), for: .normal)
            }
        }
    }
}
