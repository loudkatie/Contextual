//  AppMain.swift
//  Contextual
//

import SwiftUI

@main
struct AppMain: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false

    var body: some Scene {
        WindowGroup {
            // TEMP: Force launch into Developer Menu for screenshots and demos.
            DeveloperMenuView()
                .environmentObject(LocationService.shared)

            // ORIGINAL FLOW (restore later by commenting out the line above and
            // uncommenting the block below):
            /*
            if !hasCompletedOnboarding {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            showOnboarding = true
                        }
                    }
                    .fullScreenCover(isPresented: $showOnboarding) {
                        OnboardingView()
                    }
            } else {
                HomeView(
                    viewModel: HomeViewModel(contextService: LocationService.shared)
                )
                .environmentObject(LocationService.shared)
            }
            */
        }
    }
}
