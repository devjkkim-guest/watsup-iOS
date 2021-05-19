//
//  RegisterEmotionViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/03/30.
//

import UIKit

class RegisterEmotionViewController: UIViewController {
    var date: Date?
    @IBOutlet weak var selectEmotionView: SelectEmotionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        title = formatter.string(from: date ?? Date())
    }
    
    @IBAction func onClickRegister(_ sender: UIButton) {
        if let message = selectEmotionView.tfMessage.text,
           let emotionType = selectEmotionView.emotion?.getTypeIntValue(),
           let createdAt = date?.timeIntervalSince1970 {
            // To do: timeRecognizable 적절히 넣기
            let req = PostEmotionRequest(message: message, emotionType: emotionType, score: 0, createdAt: createdAt, timeRecognizable: 1)
            API.shared.postEmotion(req) { response in
                switch response {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }else{
            showAlert(message: "no message or no emotion selected or data lost")
        }
    }
}
