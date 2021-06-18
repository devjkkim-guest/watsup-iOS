//
//  GroupInvitedTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit

class GroupInvitedTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: GroupInvitedCollectionViewCellDelegate?
    var invitedGroups: [InboxGroupResponse]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GroupInvitedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 122, height: 156)
        layout.scrollDirection = .horizontal
        return layout
    }
}

extension GroupInvitedTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GroupInvitedCollectionViewCell {
            let group = invitedGroups?[indexPath.row]
            cell.roundedView(radius: 8)
            cell.groupName.text = group?.name
            cell.groupUUID = group?.groupUuid
            cell.delegate = delegate
            return cell
        }else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
    }
}

extension GroupInvitedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invitedGroups?.count ?? 0
    }
}
