//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var fakeSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realSelectEmotionView: SelectEmotionView!
    @IBOutlet weak var realEmotionView: UIView!
    @IBOutlet weak var btnToggleReal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realEmotionView.isHidden = true
        realEmotionView.alpha = 0
        realEmotionView.layer.cornerRadius = 14
        fakeSelectEmotionView.tfMessage.placeholder = "오늘 기분 어때요?"
        realSelectEmotionView.tfMessage.placeholder = "사실은요..."
    }
    
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
    
    @IBAction func onClickConfirmEmotion(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
