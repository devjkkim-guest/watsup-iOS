//
//  GroupMemberTableViewCell.swift
//  watsup
//
//  Created by ashon on 2021/04/07.
//

import UIKit

protocol GroupMemberTableViewCellDelegate: class {
    func didClickExpel(_ sender: UIButton)
}

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var expelButton: UIButton!
    weak var delegate: GroupMemberTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user: User?, emotion: Emotion?) {
        nameLabel.text = user?.profile?.nickname
        if let emotion = emotion {
            emotionLabel.text = EmotionType.getEmotion(rawValue: emotion.emotionType).rawValue
            messageLabel.text = emotion.message
        }
    }
    
    @IBAction func onClickExpel(_ sender: UIButton) {
        delegate?.didClickExpel(sender)
    }
}
