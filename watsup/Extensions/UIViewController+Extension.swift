//
//  UIViewController+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/18.
//

import UIKit

extension UIViewController {
    func showAlert(apiError: APIError) {
        let alertController = UIAlertController(title: nil, message: apiError.errorMsg, preferredStyle: .alert)
        let title = "Button.OK".localized
        let actionOK = UIAlertAction(title: title, style: .default, handler: nil)
        alertController.addAction(actionOK)
        
        present(alertController, animated: true, completion: nil)
    }
}