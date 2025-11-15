//
//  DeveloperMenuView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI
import AVFoundation

struct DeveloperMenuView: View {
    @State private var showScreenshotMode = false

    var body: some View {
        NavigationStack {
            List {
                Section("Previews") {
                    NavigationLink("Design Preview") { DesignPreviewView() }
                }
                Section("FTUE") {
                    NavigationLink("Welcome") { WelcomeView(onContinue: {}) }
                    NavigationLink("Permissions Flow") { PermissionsFlowView(onDone: {}) }
                    NavigationLink("Test Whisper") { TestWhisperView() }
                }
                Section("Tools") {
                    NavigationLink("Debug Tools") { DebugView() }
                    Toggle("Screenshot Mode", isOn: $showScreenshotMode)
                }
                Section("Demo") {
                    Button("Simulate Gate Whisper") {
                        speak("You’re near University Ave and have 15 minutes free. Want to send Joe the deck now?")
                    }
                }
            }
            .navigationTitle("Developer Menu")
        }
    }

    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        if let alex = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex) {
            utterance.voice = alex
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.0
        AVSpeechSynthesizer().speak(utterance)
    }
}

#Preview { DeveloperMenuView() }
