//
//  EmotionListTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/24.
//

import UIKit

class EmotionListTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.layer.cornerRadius = 6
        timeLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(emotion: Emotion) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: Date(timeIntervalSince1970: Double(emotion.createdAt)))
        timeLabel.text = time
        emotionLabel.text = EmotionType.getEmotion(rawValue: emotion.emotionType).rawValue
        commentLabel.text = emotion.message
    }
}
