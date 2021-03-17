//
//  Date+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/27.
//

import Foundation

extension Date {
    static func getNewMonth(offset: Int, from date: Date) -> Date? {
        let currentYear = Calendar.current.component(.year, from: date)
        let currentMonth = Calendar.current.component(.month, from: date)
        
        var dateComponents = DateComponents()
        let newMonth = currentMonth+offset
        
        if newMonth > 12 {
            dateComponents.year = currentYear+newMonth/12
            dateComponents.month = newMonth%12
        }else if newMonth < 1 {
            dateComponents.year = currentYear+newMonth/12-1
            dateComponents.month = newMonth+12*(-newMonth/12+1)
        }else{
            dateComponents.year = currentYear
            dateComponents.month = newMonth
        }

        let newDate = Calendar.current.date(from: dateComponents)
        return newDate
    }
}
