//
//  ReminderStore.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/5/22.
//

import Foundation
import EventKit

class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
    
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    func requestAcess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .notDetermined:
            let acessGranted = try await ekStore.requestAccess(to: .reminder)
            guard acessGranted else {
                throw TodayError.accessDenied
            }
        case .restricted:
            throw TodayError.acessRestricted
        case .denied:
            throw TodayError.accessDenied
        case .authorized:
            return
        @unknown default:
            throw TodayError.unknown
        }
    }
    
    func redAll() async throws -> [Reminder] {
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminder = try await ekStore.fetchReminder(matching: predicate)
        let reminders: [Reminder] = try ekReminder.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
}
