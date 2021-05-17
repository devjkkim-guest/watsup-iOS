//
//  GroupInvitedCollectionViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

protocol GroupInvitedCollectionViewCellDelegate: AnyObject {
    func onClickJoin(groupUUID: String)
}

class GroupInvitedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    var groupUUID: String?
    weak var delegate: GroupInvitedCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.roundedView(radius: profileImageView.bounds.height/2)
    }
    
    @IBAction func onClickJoin(_ sender: UIButton) {
        guard let groupUUID = groupUUID else { return }
        delegate?.onClickJoin(groupUUID: groupUUID)
    }
}
