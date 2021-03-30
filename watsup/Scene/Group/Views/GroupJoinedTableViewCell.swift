//
//  GroupJoinedTableViewCell.swift
//  watsup
//
//  Created by ashon on 2021/03/30.
//

import UIKit

class GroupJoinedTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String?) {
        nameLabel.text = name
    }
}
