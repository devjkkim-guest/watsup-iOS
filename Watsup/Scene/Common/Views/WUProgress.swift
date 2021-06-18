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
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .wuColor(name: .ThemeColor)
    }
    
    private func show() {
        ProgressHUD.show()
    }
    
    static func show() {
        shared.show()
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
