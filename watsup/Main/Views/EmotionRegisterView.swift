//
//  EmotionRegisterView.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import UIKit

protocol EmotionRegisterViewDelegate: class {
    func onClickRegisterEmotion(emotionLog: EmotionLog)
}

class EmotionRegisterView: XibView {
 
    weak var delegate: EmotionRegisterViewDelegate?
    
    @IBOutlet weak var fakeSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realEmotionView: UIView!
    @IBOutlet weak var btnToggleReal: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
        
        fakeSelectEmotionView.tfMessage.placeholder = "오늘 기분 어때요?"
        realSelectEmotionView.tfMessage.placeholder = "사실은요..."
    }
    
    // MARK: - IBActions
    @IBAction func onClickToggleRealEmotionView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.5) {
                self.realEmotionView.isHidden = false
            } completion: { bool in
                UIView.animate(withDuration: 0.5) {
                    self.realEmotionView.alpha = 1
                }
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.realEmotionView.alpha = 0
            } completion: { bool in
                UIView.animate(withDuration: 0.5) {
                    self.realEmotionView.isHidden = true
                    
                }
            }
        }
    }
    
    @IBAction func onClickRegiserEmotion(_ sender: UIButton) {
        let message = fakeSelectEmotionView.tfMessage.text
        if let emotion = fakeSelectEmotionView.emotion {
            let emotionLog = EmotionModel(message: message, emotion: emotion)
            delegate?.onClickRegisterEmotion(emotionLog: emotionLog)
        }else{
            print("no emotion selected")
        }
    }
}
