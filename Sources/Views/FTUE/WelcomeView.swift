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
            Image(systemName: "sparkles")
                .font(.system(size: 36, weight: .regular))
                .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.25).opacity(0.7))
            Text("contextual")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .kerning(1.0)
            Text("An ambient concierge that whispers when it matters.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
            Button("Continue") { onContinue?() }
                .font(.headline)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(.bottom, 42)
        }
        .padding()
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { WelcomeView(onContinue: {}) }
