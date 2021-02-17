//
//  String+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/18.
//

import Foundation

extension String {
    /// returns localized string
    var localized: String {
        return NSLocalizedString(self, tableName: "Localization", comment: "")
    }
}
