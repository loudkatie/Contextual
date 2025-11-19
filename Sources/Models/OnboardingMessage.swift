//
//  OnboardingMessage.swift
//  Contextual
//
//  Chat-based onboarding message model
//

import Foundation

enum OnboardingMessage: Identifiable, Equatable {
    case contextual(String)
    case user(String)
    case permissionRequest(PermissionType)
    case typing

    var id: String {
        switch self {
        case .contextual(let text): return "c_\(text.prefix(20))"
        case .user(let text): return "u_\(text.prefix(20))"
        case .permissionRequest(let type): return "p_\(type.rawValue)"
        case .typing: return "typing"
        }
    }

    enum PermissionType: String {
        case location
        case audio
        case calendar
        case tasks
        case contacts
        case photos
    }
}

enum OnboardingSession: Int {
    case one = 1    // Name, Location, Audio - Core functionality
    case two = 2    // Calendar, Tasks - After first whisper
    case three = 3  // Contacts, Photos - After 3 days of use
}
