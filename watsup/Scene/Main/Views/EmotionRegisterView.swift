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
    
    @IBOutlet weak var fakeContainer: UIVisualEffectView!
    @IBOutlet weak var fakeSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realContainer: UIVisualEffectView!
    @IBOutlet weak var btnToggleReal: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
        
        realContainer.alpha = 0
        realContainer.isHidden = true
        
        fakeSelectEmotionView.tfMessage.placeholder = "오늘 기분 어때요?"
        realSelectEmotionView.tfMessage.placeholder = "사실은요...."
        
        fakeContainer.roundedView()
        realContainer.roundedView()
        btnRegister.roundedButton()
    }
    
    // MARK: - IBActions
    @IBAction func onClickToggleRealContainer(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.5) {
                self.realContainer.isHidden = false
            } completion: { bool in
                UIView.animate(withDuration: 0.5) {
                    self.realContainer.alpha = 1
                }
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.realContainer.alpha = 0
            } completion: { bool in
                UIView.animate(withDuration: 0.5) {
                    self.realContainer.isHidden = true
                    
                }
            }
        }
    }
    
    @IBAction func onClickRegisterEmotion(_ sender: UIButton) {
        let message = fakeSelectEmotionView.tfMessage.text
        if let emotion = fakeSelectEmotionView.emotion {
            let emotionLog = EmotionLog(message: message, emotion: emotion)
            delegate?.onClickRegisterEmotion(emotionLog: emotionLog)
        }else{
            print("no emotion selected")
        }
    }
}
