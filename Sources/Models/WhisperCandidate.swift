//
//  WhisperCandidate.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation

/// A lightweight representation of a possible whisper.
/// The WhisperEngine will rank these and choose from them.
struct WhisperCandidate: Identifiable {
    let id = UUID()
    let type: WhisperType
    let reason: String
    let score: Double
    let metadata: [String: String]?

    enum WhisperType: String {
        case opportunity
        case benefit
        case memory
        case social
        case reminder
    }
}
