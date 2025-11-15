//
//  WhisperScript.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import Foundation

struct WhisperScript: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var body: String
    var cta: String?

    static let sample = WhisperScript(
        title: "Blue Bottle",
        body: "You’re free for 15 minutes near Blue Bottle. Send Joe the deck now?",
        cta: nil
    )
}
