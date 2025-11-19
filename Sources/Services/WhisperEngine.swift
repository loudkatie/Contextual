//
//  WhisperEngine.swift
//  Contextual
//
//  Created by Loud Labs Team
//  Copyright © 2025 Loud Labs. All rights reserved.
//

import Foundation
import AVFoundation
import Combine
import UIKit

/// WhisperEngine orchestrates the delivery of audio-first whispers.
/// It manages TTS, haptics, transcripts, and rate limiting.
final class WhisperEngine: NSObject, ObservableObject {
    
    // MARK: - Published State
    
    /// The text of the last whisper delivered (for display in transcript chip)
    @Published var lastTranscript: String?
    
    /// Whether a whisper is currently playing
    @Published var isWhispering: Bool = false
    
    // MARK: - Dependencies
    
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - State
    
    private var lastWhisperDate: Date?
    private var lastWhisperCategory: String?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Configuration
    
    private let globalRateLimitSeconds: TimeInterval = 120  // 2 minutes between any whispers
    private let categoryRateLimitSeconds: TimeInterval = 300  // 5 minutes per category
    
    // MARK: - Initialization

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    // MARK: - Audio Session Setup

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("✅ WhisperEngine: Audio session configured for background playback")
        } catch {
            print("❌ WhisperEngine: Failed to configure audio session: \(error)")
        }
    }
    
    // MARK: - Public Interface
    
    /// Evaluates a whisper and delivers it if rate limits allow.
    /// - Parameters:
    ///   - text: The whisper text to speak
    ///   - category: The whisper category (for category-specific rate limiting)
    func speak(text: String, category: String) {
        // Check rate limits
        guard canWhisper(category: category) else {
            print("⏸️ WhisperEngine: Rate limit blocked whisper in category '\(category)'")
            return
        }
        
        print("🔊 WhisperEngine: Delivering whisper - \(text)")
        
        // Trigger haptic (light tap)
        triggerHaptic()
        
        // Set state
        isWhispering = true
        lastTranscript = text
        
        // Speak the whisper
        let utterance = AVSpeechUtterance(string: text)

        // Voice selection: Try to use a premium, natural-sounding voice
        if let samanthaVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.en-US.Samantha") {
            utterance.voice = samanthaVoice
        } else if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        }

        // Whisper-like pacing: slower and softer
        utterance.rate = 0.45  // Slightly slower than default for clarity
        utterance.volume = 0.75  // Softer volume for "whisper" effect
        utterance.pitchMultiplier = 0.95  // Slightly lower pitch for intimacy
        utterance.preUtteranceDelay = 0.2  // Brief pause before speaking
        
        synthesizer.speak(utterance)
        
        // Record whisper for rate limiting
        lastWhisperDate = Date()
        lastWhisperCategory = category
        
        // Auto-clear transcript after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.lastTranscript = nil
        }
    }
    
    // MARK: - Private Helpers
    
    private func canWhisper(category: String) -> Bool {
        guard let lastDate = lastWhisperDate else {
            return true  // Never whispered before
        }
        
        let timeSinceLastWhisper = Date().timeIntervalSince(lastDate)
        
        // Check global rate limit
        if timeSinceLastWhisper < globalRateLimitSeconds {
            return false
        }
        
        // Check category-specific rate limit
        if lastWhisperCategory == category && timeSinceLastWhisper < categoryRateLimitSeconds {
            return false
        }
        
        return true
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension WhisperEngine: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isWhispering = false
        }
        print("✅ WhisperEngine: Whisper finished")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isWhispering = false
        }
        print("❌ WhisperEngine: Whisper cancelled")
    }
}
