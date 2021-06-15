//
//  WUProgress.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/06/15.
//
import ProgressHUD

class WUProgress {
    private static let shared = WUProgress()
    private init() {
        ProgressHUD.colorHUD = .wuColor(name: .ThemeColor)
    }
    
    private func show() {
        ProgressHUD.show("text")
    }
    
    static func show() {
        shared.show()
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
