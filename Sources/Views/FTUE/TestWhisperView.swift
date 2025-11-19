//
//  TestWhisperView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI
import AVFoundation

struct TestWhisperView: View {
    var onContinue: (() -> Void)?

    @State private var transcript: String? = WhisperScript.sample.body
    @State private var hasPlayed = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "waveform")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(red: 0.46, green: 0.52, blue: 0.60))
                .padding(.bottom, 10)

            Text("Try a whisper")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .kerning(0.5)

            Text("This is what you'll hear when Contextual has something to tell you.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

            if let transcript {
                Text("\"\(transcript)\"")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary.opacity(0.7))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.5))
                    )
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: { speak(WhisperScript.sample.body) }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play Sample Whisper")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue, in: Capsule())
                }

                if hasPlayed {
                    Button(action: { onContinue?() }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .padding()
        .navigationTitle("Test Whisper")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func speak(_ text: String) {
        hasPlayed = true
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.volume = 0.85
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        AVSpeechSynthesizer().speak(utterance)
    }
}

#Preview { TestWhisperView() }
