//
//  EKEventStore+AsyncFetch.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/5/22.
//

import Foundation
import EventKit

extension EKEventStore {
    func fetchReminder(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders = reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
                
            }
        }
    }
}
