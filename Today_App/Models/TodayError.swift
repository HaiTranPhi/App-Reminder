//
//  TodayError.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/5/22.
//

import Foundation


enum TodayError: LocalizedError {
    case accessDenied
    case acessRestricted
    case failedReadingCalendarItem
    case failedReadingReminders
    case reminderHasNoDueDate
    case unknown
    
    var errorDescription: String? {
        switch self {
        case.accessDenied:
            return NSLocalizedString("The app doesn't have permission to red reminders", comment: "access denied error description")
        case.acessRestricted:
            return NSLocalizedString("This device doesn't allow to reminder", comment: "acess restricted error description")
        case.failedReadingCalendarItem:
            return NSLocalizedString("Failed to read a calendar item", comment: "failed reading calendar item error description")
        case.failedReadingReminders:
            return NSLocalizedString("Failed to read reminder", comment: "failed reading reminder error description")
        case.reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date", comment: "reminder has no due date error discription")
        case.unknown:
            return NSLocalizedString("An unknown error occurred", comment: "unknown error description")
        }
    }
}
