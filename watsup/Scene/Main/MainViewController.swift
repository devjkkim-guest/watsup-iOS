//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var emotionRegisterView: EmotionRegisterView!
    @IBOutlet weak var emotionRegisterViewBottom: NSLayoutConstraint!
    @IBOutlet weak var randomEmotionView: RandomEmotionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emotionRegisterView.delegate = self
        
        randomEmotionView.frame = view.bounds
        randomEmotionView.myEmotionView.isHidden = true
        
        setKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        randomEmotionView.myEmotionView.center = randomEmotionView.center
        view.layoutIfNeeded()
        view.layoutSubviews()
    }
    
    // MARK: set
    /// adjust view when keyboard shows up
    override func keyboardWillShow(_ sender: NSNotification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.5) {
                self.emotionRegisterViewBottom.constant = keyboardFrame.cgRectValue.height
            }
        }
    }
    
    /// adjust view when keyboard hidden
    override func keyboardWillHide(_ sender: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.emotionRegisterViewBottom.constant = 0
        }
    }
}

extension MainViewController: EmotionRegisterViewDelegate {
    func onClickRegisterEmotion(emotionLog: EmotionLog) {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.5) {
            self.emotionRegisterView.alpha = 0
        } completion: { _ in
            self.randomEmotionView.myEmotionView.isHidden = false
            self.randomEmotionView.myEmotionView.alpha = 0
            self.randomEmotionView.setMyEmotion(emotionLog: emotionLog)
            
            UIView.animate(withDuration: 0.5) {
                self.randomEmotionView.myEmotionView.alpha = 1
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                let message = ["hello", "hi", "funny", "oh", "sad", "haha"].randomElement()
                let emotion = EmotionType.allCases.randomElement() ?? .crying
                let emotionLog = EmotionModel(message: message, emotion: emotion)
                self.randomEmotionView.addEmotion(emotionLog: emotionLog)
            }
        }
    }
}
