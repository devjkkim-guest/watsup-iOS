//
//  RegisterEmotionTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/30.
//

import UIKit

protocol RegisterEmotionTableViewCellDelegate: class {
    func didClickRegister(_ date: Date)
}

class RegisterEmotionTableViewCell: UITableViewCell {

    @IBOutlet weak var registerButton: UIButton!
    weak var delegate: RegisterEmotionTableViewCellDelegate?
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickRegister(_ sender: UIButton) {
        guard let date = date else { return }
        delegate?.didClickRegister(date)
    }
}
