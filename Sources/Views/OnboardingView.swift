//
//  OnboardingView.swift
//  Contextual
//
//  Complete onboarding flow: Welcome → Permissions → Test Whisper → Done
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep = 0

    private let totalSteps = 3

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.96, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<totalSteps, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentStep ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 60)
                .padding(.bottom, 20)

                // Content
                TabView(selection: $currentStep) {
                    WelcomeView(onContinue: {
                        withAnimation {
                            currentStep = 1
                        }
                    })
                    .tag(0)

                    PermissionsFlowView(onDone: {
                        withAnimation {
                            currentStep = 2
                        }
                    })
                    .tag(1)

                    TestWhisperView(onContinue: {
                        completeOnboarding()
                    })
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .interactiveDismissDisabled()
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        dismiss()
    }
}
