//
//  UIViewController+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/18.
//

import UIKit
import PhotosUI
import MobileCoreServices

extension UIViewController {
    func showAlert(apiError: APIError) {
        let alertController = UIAlertController(title: nil, message: apiError.errorMsg, preferredStyle: .alert)
        let title = "Button.OK".localized
        let actionOK = UIAlertAction(title: title, style: .default, handler: nil)
        alertController.addAction(actionOK)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let title = "Button.OK".localized
        let actionOK = UIAlertAction(title: title, style: .default, handler: nil)
        alertController.addAction(actionOK)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func endEditingWhenTapBackground() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func requestPhotoAccess(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            presentImagePicker(delegate: delegate)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.presentImagePicker(delegate: delegate)
                    } else {
                        self.presentPhotoAccessAlert()
                    }
                }
            }
        case .restricted, .denied:
            presentPhotoAccessAlert()
        default:
            break
        }
    }
    
    func presentImagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeImage as String]
        vc.allowsEditing = false
        vc.delegate = delegate
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoAccessAlert() {
        let alertController = UIAlertController(title: nil, message: "사진 접근 권한을 허용해주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정 바로가기", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                })
            }
        }
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
}
