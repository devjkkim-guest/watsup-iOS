//
//  RandomEmotionView.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import UIKit

class RandomEmotionView: XibView {
    
    @IBOutlet weak var myEmotionView: EmotionView!
    
    /// emotions to be removed by timer
    var emotions = [EmotionView]()
    var timer: Timer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if let emotion = self.emotions.first {
                UIView.animate(withDuration: 0.5) {
                    self.myEmotionView.center = self.center
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                    emotion.alpha = 0
                } completion: { _ in
                    self.emotions.removeFirst()
                    emotion.removeFromSuperview()
                    self.myEmotionView.center = self.center
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func setMyEmotion(emotionLog: EmotionLog) {
        myEmotionView.set(emotionLog: emotionLog)
        myEmotionView.backgroundColor = .darkGray
        self.addSubview(myEmotionView)
        myEmotionView.center = self.center
        self.layoutIfNeeded()
        self.layoutSubviews()
//        myEmotionView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func addEmotion(emotionLog: EmotionLog) {
        let emotion = EmotionView(emotionLog: emotionLog)
        emotion.set(emotionLog: emotionLog)
        emotion.setSize(.E1)
        self.insertSubview(emotion, belowSubview: myEmotionView)
        myEmotionView.center = self.center
        self.layoutIfNeeded()
        self.layoutSubviews()
        emotions.append(emotion)
    }
}
