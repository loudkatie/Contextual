//
//  WelcomeView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI

struct WelcomeView: View {
    var onContinue: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(red: 0.46, green: 0.52, blue: 0.60))
                .padding(.bottom, 10)

            // Wordmark
            Text("contextual")
                .font(.system(size: 32, weight: .light))
                .kerning(3.0)
                .foregroundColor(Color(red: 0.46, green: 0.52, blue: 0.60))
                .padding(.bottom, 30)

            // Tagline
            Text("An ambient layer that whispers when it matters.")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.primary.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

            // Features
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "location.fill", text: "Aware of where you are")
                FeatureRow(icon: "clock.fill", text: "Knows when you're free")
                FeatureRow(icon: "waveform", text: "Whispers through AirPods")
            }
            .padding(.horizontal, 50)

            Spacer()

            // CTA
            Button(action: { onContinue?() }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue, in: Capsule())
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .padding()
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.blue.opacity(0.8))
                .frame(width: 24)

            Text(text)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.primary.opacity(0.8))

            Spacer()
        }
    }
}

#Preview { WelcomeView(onContinue: {}) }
