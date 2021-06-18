//
//  CalendarCollectionViewCell.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/27.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayMark: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dayMark.layer.cornerRadius = dayMark.frame.width/2
    }
}
