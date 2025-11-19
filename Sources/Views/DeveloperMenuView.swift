//
//  DeveloperMenuView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI
import AVFoundation

struct DeveloperMenuView: View {
    @EnvironmentObject var gateEngine: GateRuleEngine
    @State private var showScreenshotMode = false

    var body: some View {
        NavigationStack {
            List {
                Section("Active Route") {
                    Picker("Route", selection: Binding(
                        get: { gateEngine.activeRoute },
                        set: { gateEngine.switchRoute(to: $0) }
                    )) {
                        ForEach(GateRuleEngine.DemoRoute.allCases, id: \.self) { route in
                            Text(route.rawValue).tag(route)
                        }
                    }
                    .pickerStyle(.menu)
                }

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

                Section("Quick Tests") {
                    Button("🎙️ Test Random Whisper") {
                        speak("You're near University Ave and have 15 minutes free. Want to send Joe the deck now?")
                    }
                    Button("🧪 Simulate Starbucks Entry") {
                        LocationService.shared.onGateEntry?("starbucks_sancarlos")
                    }
                    Button("🧪 Simulate Blue Bottle Entry") {
                        LocationService.shared.onGateEntry?("bluebottle_paloalto")
                    }
                    Button("🧪 Simulate Dolores Park Entry") {
                        LocationService.shared.onGateEntry?("dolores_park")
                    }
                }

                Section("Reset") {
                    Button("Reset Onboarding") {
                        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                    }
                    .foregroundColor(.red)
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
