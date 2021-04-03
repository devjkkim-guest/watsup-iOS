//
//  EmotionListTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/24.
//

import UIKit

class EmotionListTableViewCell: UITableViewCell {

    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(emotion: Int, comment: String?) {
        emotionLabel.text = EmotionType.getEmotion(rawValue: emotion).rawValue
        commentLabel.text = comment
    }
}
