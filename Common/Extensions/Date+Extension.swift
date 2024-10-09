//
//  Date+Extension.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 9/22/24.
//

import Foundation

extension Date {
    /// Transforms the date in a string representation.
    func dateString(
        with dateStyle:  DateFormatter.Style = .medium,
        isDisplayingTime: Bool = true,
        and timeStyle:  DateFormatter.Style = .short
    ) -> String {
        let formatter = DateFormatter()
        let currentLocale = Locale.current
        
        formatter.dateStyle = dateStyle
        
        if isDisplayingTime {
            formatter.timeStyle = timeStyle
        }
        
        formatter.locale = currentLocale
        
        return formatter.string(from: self)
    }
}

extension Date {
    static func randomDate() -> Date {
        let year = Calendar.current.component(.year, from: .now)
        let month = Calendar.current.component(.month, from: .now)
        let currentDay = Calendar.current.component(.day, from: .now)
        let day = Int.random(in: 1...currentDay)
        
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components) ?? .now
    }
}
