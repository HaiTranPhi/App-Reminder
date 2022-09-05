//
//  Reminder+EkReminder.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/5/22.
//

import Foundation
import EventKit

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let duedate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        self.dueDate = duedate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
