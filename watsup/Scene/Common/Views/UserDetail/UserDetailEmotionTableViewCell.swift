//
//  UserDetailEmotionTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/19.
//

import UIKit

class UserDetailEmotionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "M/dd"
        timeFormatter.dateFormat = "HH:mm"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(emotion: Emotion?) {
        if let emotion = emotion {
            dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: emotion.createdAt))
            timeLabel.text = timeFormatter.string(from: Date(timeIntervalSince1970: emotion.createdAt))
            emotionLabel.text = EmotionType.getEmotion(rawValue: emotion.emotionType).rawValue
            messageLabel.text = emotion.message
        }
    }
}
