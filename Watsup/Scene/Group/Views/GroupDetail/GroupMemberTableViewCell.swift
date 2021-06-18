//
//  GroupMemberTableViewCell.swift
//  watsup
//
//  Created by ashon on 2021/04/07.
//

import UIKit

protocol GroupMemberTableViewCellDelegate: AnyObject {
    func didClickExpel(_ sender: UIButton)
}

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var uuid: String?
    let dateFormatter = DateFormatter()
    weak var delegate: GroupMemberTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emotionLabel.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        dateFormatter.dateFormat = "HH:mm"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(joinedUser: JoinedUser?, emotion: Emotion?) {
        guard let joinedUser = joinedUser, let user = joinedUser.user else {
            timeLabel.isHidden = true
            emotionLabel.isHidden = true
            messageLabel.isHidden = true
            return
        }
        
        uuid = user.uuid
        nameLabel.text = user.profile?.nickname
        
        if joinedUser.userStatus == .invited {
            timeLabel.isHidden = true
            emotionLabel.isHidden = true
            messageLabel.text = "Waiting for join..."
        } else if let emotion = emotion {
            timeLabel.isHidden = false
            timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: emotion.createdAt))
            emotionLabel.isHidden = false
            emotionLabel.text = EmotionType.getEmotion(rawValue: emotion.emotionType).rawValue
            messageLabel.text = emotion.message
        } else {
            timeLabel.isHidden = true
            emotionLabel.isHidden = true
            messageLabel.text = "Emotion.NoEmotion".localized
        }
    }
    
    @IBAction func onClickExpel(_ sender: UIButton) {
        delegate?.didClickExpel(sender)
    }
}
