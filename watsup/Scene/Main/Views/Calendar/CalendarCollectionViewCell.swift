//
//  CalendarCollectionViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/27.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var todayMark: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        todayMark.layer.cornerRadius = todayMark.frame.width/2
    }
}
