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

    // MARK: - Public API

    /// Direct whisper delivery for memory whispers and pre-formatted scripts.
    /// Use this when you have a complete message to speak.
    func speak(_ message: String) {
        guard shouldSpeak() else {
            print("WhisperEngine: Rate limited, skipping whisper")
            return
        }
        deliverWhisper(message)
    }

    /// Legacy entry point for gate-based events.
    /// Generates a whisper from event type (enter/exit).
    func evaluate(event: String) {
        let whisper = generateWhisper(from: event)

        if shouldSpeak() {
            deliverWhisper(whisper)
        }
    }

    // MARK: - Private Implementation

    /// Placeholder for real LLM + ranking logic.
    private func generateWhisper(from event: String) -> String {
        if event.contains("enter") {
            return "You've arrived at a meaningful place."
        }
        if event.contains("exit") {
            return "Leaving now."
        }
        return "Noted."
    }

    /// Rate limit check: 60 seconds between whispers
    private func shouldSpeak() -> Bool {
        let now = Date()
        if let last = lastWhisperDate,
           now.timeIntervalSince(last) < 60 {
            return false
        }
        return true
    }

    /// Internal method to actually deliver the whisper via TTS
    private func deliverWhisper(_ message: String) {
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
