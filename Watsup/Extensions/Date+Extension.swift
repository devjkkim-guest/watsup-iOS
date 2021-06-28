//
//  Date+Extension.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/02/27.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var monthSymoble: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter.string(from: self)
    }
    
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
    
    /**
     첫번째 날로부터 offset만큼 떨어진 날짜 반환
     - Parameters:
        - offset: CollectionViewCell의 IndexPath.item
     */
    func getDate(offset day: Int) -> Date? {
        let weekDay = Calendar.current.component(.weekday, from: self)
        let dayOffset = day-(weekDay-1)
        return Calendar.current.date(byAdding: .day, value: dayOffset, to: self, wrappingComponents: false)
    }
    
    func hasEmotion() -> Bool {
        return !DatabaseWorker.shared.getEmotions(from: self.startOfDay, to: self.endOfDay).isEmpty
    }
}
