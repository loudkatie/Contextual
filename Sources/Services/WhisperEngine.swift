//
//  WhisperEngine.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation
import AVFoundation
import Combine

/// WhisperEngine decides *whether* to whisper and *what* to whisper.
/// This is the heart of the Contextual experience.
final class WhisperEngine: NSObject, ObservableObject {

    @Published var lastWhisper: String?

    private let synthesizer = AVSpeechSynthesizer()
    private var cancellables = Set<AnyCancellable>()
    private var lastWhisperDate: Date?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Entry point: call this when the app detects something meaningful (gate entry, motion shift, etc.)
    func evaluate(event: String) {
        let whisper = generateWhisper(from: event)

        // frequency cap (3 per hour as a safeguard)
        if shouldSpeak(whisper) {
            speak(whisper)
        }
    }

    /// Placeholder for real LLM + ranking logic.
    private func generateWhisper(from event: String) -> String {
        if event.contains("enter") {
            return "You’ve arrived at a meaningful place."
        }
        if event.contains("exit") {
            return "Leaving now."
        }
        return "Noted."
    }

    private func shouldSpeak(_ whisper: String) -> Bool {
        let now = Date()
        if let last = lastWhisperDate,
           now.timeIntervalSince(last) < 60 { // 60 seconds between whispers
            return false
        }
        return true
    }

    private func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = 0.45
        utterance.volume = 0.9

        lastWhisper = message
        lastWhisperDate = Date()

        synthesizer.speak(utterance)
    }
}

extension WhisperEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        // Future hook: log completion, schedule follow-up, etc.
    }
}
