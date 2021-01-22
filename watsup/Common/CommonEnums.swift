//
//  CommonEnums.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/23.
//

import Foundation

enum EmotionType: String, CaseIterable {
    /// 0<=score<=20
    case pouting = "😡"
    /// 20<score<=40
    case crying = "😢"
    /// 40<score<=60
    case neutral = "😐"
    /// 60<score<=80
    case grinning = "😄"
    /// 80<score<=100
    case smilingHeartEyes = "😍"
}
