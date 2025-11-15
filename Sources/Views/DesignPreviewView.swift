//
//  DesignPreviewView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI

struct DesignPreviewView: View {
    enum Mode: String, CaseIterable, Identifiable { case passive = "Passive", whisper = "Whisper", ftue = "FTUE"; var id: String { rawValue } }

    @State private var mode: Mode = .passive
    @State private var showTranscript: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(colors: [Color(.sRGB, red: 0.97, green: 0.98, blue: 1.0, opacity: 1.0),
                                        Color(.sRGB, red: 0.93, green: 0.95, blue: 1.0, opacity: 1.0)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    orb
                        .frame(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.48,
                               height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.48)
                    Spacer()
                    overlayForMode
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Mode", selection: $mode) {
                        ForEach(Mode.allCases) { m in Text(m.rawValue).tag(m) }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 340)
                }
            }
            .navigationTitle("Design Preview")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: mode) { _, newValue in
            if newValue == .whisper {
                withAnimation(.easeOut(duration: 0.6).delay(5.0)) { showTranscript = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) { showTranscript = true }
            }
        }
    }

    // MARK: - Orb or fallback
    private var orb: some View {
        Group {
            if let orbViewType = _typeByName("OrbView") {
                // Dynamically create OrbView if available
                if let orbViewType = orbViewType as? AnyObject.Type {
                    AnyView(
                        // Unsafe cast to OrbView assuming it has an initializer size: CGFloat
                        // Fallback to Circle if casting fails
                        (orbViewType as? View.Type).map {_ in 
                            // Since we cannot instantiate unknown View directly,
                            // fallback instead - safer for this context
                            Circle()
                                .fill(AngularGradient(colors: [Color.white, Color(red:0.92, green:0.86, blue:1.0), Color(red:0.85, green:0.93, blue:1.0), Color.white], center: .center))
                                .shadow(color: .white.opacity(0.5), radius: 22)
                        } ?? Circle()
                            .fill(AngularGradient(colors: [Color.white, Color(red:0.92, green:0.86, blue:1.0), Color(red:0.85, green:0.93, blue:1.0), Color.white], center: .center))
                            .shadow(color: .white.opacity(0.5), radius: 22)
                    )
                } else {
                    Circle()
                        .fill(AngularGradient(colors: [Color.white, Color(red:0.92, green:0.86, blue:1.0), Color(red:0.85, green:0.93, blue:1.0), Color.white], center: .center))
                        .shadow(color: .white.opacity(0.5), radius: 22)
                        .eraseToAnyView()
                }
            } else {
                Circle()
                    .fill(AngularGradient(colors: [Color.white, Color(red:0.92, green:0.86, blue:1.0), Color(red:0.85, green:0.93, blue:1.0), Color.white], center: .center))
                    .shadow(color: .white.opacity(0.5), radius: 22)
            }
        }
    }

    @ViewBuilder
    private var overlayForMode: some View {
        switch mode {
        case .passive:
            VStack(spacing: 16) {
                Text("Running quietly")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.6))
                Button("Pause Whispers") {}
                    .font(.headline)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 36)
            }
        case .whisper:
            VStack(spacing: 16) {
                if showTranscript {
                    Text("You’re free for 15 minutes near Blue Bottle. Send Joe the deck now?")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.black.opacity(0.65))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 6)
                        .transition(.opacity)
                }
                Button("Pause Whispers") {}
                    .font(.headline)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 36)
            }
        case .ftue:
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.25).opacity(0.7))
                    .padding(.bottom, 6)
                Text("contextual")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .kerning(1.0)
                    .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.25).opacity(0.85))
                Spacer(minLength: 10)
                Text("An ambient concierge that whispers when it matters.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Button("Continue") {}
                    .font(.headline)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 42)
            }
        }
    }
}

#if DEBUG
struct DesignPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        DesignPreviewView()
    }
}
#endif

private extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
