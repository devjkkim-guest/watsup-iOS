//
//  GroupMemberTableViewCell.swift
//  watsup
//
//  Created by ashon on 2021/04/07.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var expelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
