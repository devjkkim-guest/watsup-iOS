//
//  EmotionView.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import UIKit

class EmotionView: XibView {
    
    /// E1 < E2 < E3 ...
    enum EmotionViewSize: Int {
        /// 가장 작은 사이즈
        case E1 = 0
        /// 중간 사이즈
        case E2
        /// 가장 큰 사이즈
        case E3
    }
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var emotionButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
            
            // default size
            setSize(.E2)
        }
    }
    
    init(emotionLog: EmotionLog) {
        let randomX = Int.random(in: 0...Int(UIScreen.main.bounds.width))
        let randomY = Int.random(in: 0...Int(UIScreen.main.bounds.height))
        super.init(frame: CGRect(x: randomX, y: randomY, width: 100, height: 140))
        if let view = instanceFrom(object: self) {
            view.frame = self.bounds
            self.addSubview(view)
            
            // default size
            setSize(.E2)
        }
        set(emotionLog: emotionLog)
    }
    
    /// adjust font size & emotion icon size
    func setSize(_ size: EmotionViewSize) {
        let messageSize = CGFloat(15+(2*size.rawValue))
        messageButton.titleLabel?.font = .systemFont(ofSize: messageSize)
        
        let emotionSize = CGFloat(38+(10*size.rawValue))
        emotionButton.titleLabel?.font = .systemFont(ofSize: emotionSize)
    }
    
    /// set message & emotion on each buttons
    func set(emotionLog: EmotionLog) {
        if let message = emotionLog.message {
            messageButton.setTitle(message, for: .normal)
        }else{
            messageButton.isHidden = true
        }
        emotionButton.setTitle(emotionLog.emotion.rawValue, for: .normal)
    }
}
