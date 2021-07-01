//
//  SettingProfileTableViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/30.
//

import UIKit
import RxSwift
import RealmSwift

protocol SettingProfileTableViewCellDelegate: AnyObject {
    func didClickUpdateProfileImage()
    func reloadTableData()
}

class SettingProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    let viewModel: SettingViewModel = Container.shared.resolve(id: settingViewModelId)
    let disposeBag = DisposeBag()
    var notificationToken: NotificationToken?
    weak var delegate: SettingProfileTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindViewModel()
        btnProfile.layer.cornerRadius = btnProfile.frame.size.width/2
        btnProfile.clipsToBounds = true
        viewModel.getMyProfileImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateProfileImage(_ sender: UIButton) {
        delegate?.didClickUpdateProfileImage()
    }
    
    private func bindViewModel() {
        viewModel.profileImage.subscribe { [weak self] image in
            if let element = image.element, let image = element {
                self?.btnProfile.setImage(image, for: .normal)
                self?.delegate?.reloadTableData()
            }
        }.disposed(by: disposeBag)

        
        notificationToken = viewModel.myInfo?.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let data),
                 .update(let data, _, _, _):
                self.nameLabel.text = data.first?.profile?.nickname
                self.emailLabel.text = data.first?.email
                self.nameLabel.text = data.first?.profile?.nickname
                self.emailLabel.text = data.first?.email
            default:
                break
            }
            
        }
    }
}
