//
//  PassiveHomeView.swift
//  Contextual
//
//  Immersive full-screen ambient experience.
//

import SwiftUI

struct PassiveHomeView: View {
    
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var whisperEngine: WhisperEngine
    @EnvironmentObject var gateEngine: GateRuleEngine
    
    @State private var showTranscript = false
    @State private var transcriptOpacity: Double = 0.0
    @State private var isMonitoring = false
    @State private var statusText: String = "listening..."
    @State private var orbScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Deep purple gradient background (center → edges)
                RadialGradient(
                    colors: [
                        Color(red: 0.25, green: 0.20, blue: 0.35), // Deep purple center
                        Color(red: 0.18, green: 0.15, blue: 0.28), // Darker edges
                        Color(red: 0.12, green: 0.10, blue: 0.20)  // Nearly black edges
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: 600
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // Delicate wordmark at top
                    Text("c o n t e x t u a l")
                        .font(.system(size: 13, weight: .light, design: .default))
                        .tracking(4) // Letter spacing
                        .foregroundColor(Color.white.opacity(0.35))
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // HUGE centered orb
                    OrbView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(orbScale)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: orbScale)
                    
                    Spacer()
                    
                    // Status text or transcript chip
                    ZStack {
                        // Default status text
                        if showTranscript == false {
                            Text(statusText)
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(Color.white.opacity(0.4))
                                .transition(.opacity)
                        }
                        
                        // Transcript chip (ephemeral)
                        if let transcript = whisperEngine.lastTranscript, showTranscript {
                            Text(transcript)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .opacity(transcriptOpacity)
                                .padding(.horizontal, 40)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                    }
                    .frame(height: 80)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Controls
                    VStack(spacing: 16) {
                        // Pause/Resume Control
                        Button(action: toggleMonitoring) {
                            HStack(spacing: 8) {
                                Image(systemName: isMonitoring ? "pause.fill" : "play.fill")
                                    .font(.system(size: 13, weight: .semibold))
                                Text(isMonitoring ? "Pause Whispers" : "Resume Whispers")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Dev Tools Link
                        NavigationLink {
                            DeveloperMenuView()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "hammer.fill")
                                    .font(.system(size: 11, weight: .semibold))
                                Text("Developer Menu")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.08))
                            )
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark) // Force dark mode for status bar
            .onAppear {
                startMonitoring()
            }
            .onChange(of: whisperEngine.lastTranscript) { oldValue, newTranscript in
                if newTranscript != nil && newTranscript != oldValue {
                    showTranscriptChip()
                }
            }
            .onChange(of: whisperEngine.isWhispering) { _, isWhispering in
                // Pulse orb when whispering
                withAnimation {
                    orbScale = isWhispering ? 1.15 : 1.0
                }
                // Update status
                if isWhispering {
                    withAnimation {
                        statusText = "whispering..."
                    }
                } else if !showTranscript {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            statusText = "listening..."
                        }
                    }
                }
            }
            .onChange(of: locationService.lastGateEvent) { _, event in
                // Update status when entering/exiting gates
                if let event = event {
                    if event.starts(with: "enter:") {
                        let gateId = event.replacingOccurrences(of: "enter:", with: "")
                        let placeName = formatGateName(gateId)
                        withAnimation {
                            statusText = "approaching \(placeName)"
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func toggleMonitoring() {
        if isMonitoring {
            stopMonitoring()
        } else {
            startMonitoring()
        }
    }
    
    private func startMonitoring() {
        locationService.startUpdating()
        isMonitoring = true
        print("▶️ PassiveHomeView: Started monitoring")
    }
    
    private func stopMonitoring() {
        locationService.stopUpdating()
        isMonitoring = false
        print("⏸️ PassiveHomeView: Stopped monitoring")
    }
    
    private func showTranscriptChip() {
        showTranscript = true

        // Fade in
        withAnimation(.easeIn(duration: 0.3)) {
            transcriptOpacity = 1.0
        }

        // Hold for 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            // Fade out
            withAnimation(.easeOut(duration: 0.5)) {
                transcriptOpacity = 0.0
            }

            // Remove from view after fade completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showTranscript = false
            }
        }
    }

    private func formatGateName(_ gateId: String) -> String {
        // Convert "starbucks_sancarlos" → "Starbucks"
        let parts = gateId.split(separator: "_")
        guard let firstPart = parts.first else { return gateId }
        return String(firstPart).capitalized
    }
}

#Preview {
    PassiveHomeView()
        .environmentObject(LocationService.shared)
        .environmentObject(WhisperEngine())
        .environmentObject(GateRuleEngine(
            locationService: LocationService.shared,
            whisperEngine: WhisperEngine()
        ))
}
