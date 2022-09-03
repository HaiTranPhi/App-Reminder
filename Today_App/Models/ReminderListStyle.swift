//
//  ReminderListStyle.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/2/22.
//

import Foundation

enum ReminderListtyle: Int {
    case today
    case future
    case all
    
    var name: String {
        switch self {
        case.today:
            return NSLocalizedString("Today", comment: "Today style name")
        case.future:
            return NSLocalizedString("Future", comment: "Future style name")
        case.all:
            return NSLocalizedString("All", comment: "All styple name")
        }
        
    }
    
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        switch self {
        case.today:
            return isInToday
        case.future:
            return (date > Date.now) && !isInToday
        case.all:
            return true
        }
    }
}
