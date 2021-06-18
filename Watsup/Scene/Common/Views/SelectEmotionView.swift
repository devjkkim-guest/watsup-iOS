//
//  SelectEmotion.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class SelectEmotionView: XibView {
    
    @IBOutlet weak var emotionStack: UIStackView!
    @IBOutlet weak var tfMessage: UITextField!
    var emotion: EmotionType?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    @IBAction func onClickEmotion(_ sender: UIButton) {
        emotionStack.subviews.forEach{
            ($0 as? UIButton)?.alpha = 0.2
            ($0 as? UIButton)?.isSelected = false
        }
        sender.alpha = 1
        sender.isSelected = true
        
        if let emotionText = sender.titleLabel?.text {
            emotion = EmotionType(rawValue: emotionText)
        }
    }
}
