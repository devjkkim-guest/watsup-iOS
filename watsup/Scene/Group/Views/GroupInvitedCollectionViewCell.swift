//
//  GroupInvitedCollectionViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

class GroupInvitedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.roundedView(profileImageView.bounds.height/2)
    }
}
