//  AppMain.swift
//  Contextual
//
//  App entry point — initializes all services and launches UI.
//

import SwiftUI

@main
struct AppMain: App {
    
    // MARK: - Services (Initialized Once)

    private let locationService = LocationService.shared
    private let motionService = MotionService()
    private let whisperEngine = WhisperEngine()
    private let gateEngine: GateRuleEngine
    
    // MARK: - UI State
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    
    // MARK: - Initialization
    
    init() {
        // Wire services together: GateEngine depends on Location + Whisper
        gateEngine = GateRuleEngine(
            locationService: locationService,
            whisperEngine: whisperEngine
        )
        
        // Connect LocationService callbacks to GateEngine
        locationService.onGateEntry = { [gateEngine] gateId in
            gateEngine.handleGateEntry(gateId: gateId)
        }
        
        locationService.onGateExit = { [gateEngine] gateId in
            gateEngine.handleGateExit(gateId: gateId)
        }

        // DON'T request permissions on launch - let onboarding handle it

        print("✅ AppMain: Services initialized and wired")
    }
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                SplashView()
                    .onAppear {
                        // Auto-transition to onboarding after splash - let it breathe (4 seconds)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            showOnboarding = true
                        }
                    }
                    .fullScreenCover(isPresented: $showOnboarding) {
                        ConversationalOnboardingView()
                            .environmentObject(locationService)
                            .environmentObject(motionService)
                            .environmentObject(whisperEngine)
                            .environmentObject(gateEngine)
                    }
            } else {
                PassiveHomeView()
                    .environmentObject(locationService)
                    .environmentObject(motionService)
                    .environmentObject(whisperEngine)
                    .environmentObject(gateEngine)
            }
        }
    }
}
