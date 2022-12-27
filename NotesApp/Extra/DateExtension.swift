//
//  Extensions.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

extension Date {
    static func isToday(day: Int) -> Bool {
        return Calendar.current.dateComponents([.day], from: .now).day == day
    }
    
    static func isThisYear(year: Int) -> Bool {
        return Calendar.current.dateComponents([.year], from: .now).year == year
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
