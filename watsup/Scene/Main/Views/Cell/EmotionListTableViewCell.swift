//
//  EmotionListTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/24.
//

import UIKit

class EmotionListTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(day: Int, comment: String) {
        dayLabel.text = String(day)
        commentLabel.text = comment
    }
}
