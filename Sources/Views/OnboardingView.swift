//
//  OnboardingView.swift
//  Contextual
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Contextual")
                .font(.title)
                .multilineTextAlignment(.center)

            Text("We’ll whisper when time, place, and motion line up with what matters.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Turn on Contextual") {
                hasCompletedOnboarding = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
