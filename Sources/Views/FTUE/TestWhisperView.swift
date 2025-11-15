//
//  TestWhisperView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI
import AVFoundation

struct TestWhisperView: View {
    @State private var transcript: String? = WhisperScript.sample.body

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Play a sample whisper").font(.title3)
            if let transcript {
                Text(transcript)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
            Button("Play Sample") { speak(WhisperScript.sample.body) }
                .font(.headline)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(.bottom, 42)
        }
        .padding()
        .navigationTitle("Test Whisper")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview { TestWhisperView() }
