//
//  BaseAuthViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/06/15.
//

import UIKit
import SnapKit

class BaseAuthViewController: UIViewController {
    let bottomButton = Bundle.main.loadNibNamed("BottomButton", owner: self, options: nil)?.first as! BottomButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
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
