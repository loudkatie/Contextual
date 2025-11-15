//
//  AppEvent.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation

/// Represents any meaningful event inside the system.
/// Used for debugging, diagnostics, and whisper candidate generation.
struct AppEvent: Identifiable {
    let id = UUID()
    let timestamp = Date()
    let type: EventType
    let metadata: [String: String]

    enum EventType: String {
        case locationEnter
        case locationExit
        case motionChange
        case whisperFired
        case unknown
    }
}
