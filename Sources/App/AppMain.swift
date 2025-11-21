//
//  AppMain.swift
//  Contextual
//
//  Main app entry point - wires together all services for memory whispers.
//

import SwiftUI

@main
struct ContextualApp: App {

    // MARK: - Core Services

    /// Location monitoring (region + significant changes)
    @StateObject private var locationService = LocationService()

    /// Motion detection for activity context
    @StateObject private var motionService = MotionService()

    /// Photo library spatial index
    @StateObject private var photosService = PhotosService()

    /// TTS whisper delivery
    @StateObject private var whisperEngine = WhisperEngine()

    // MARK: - Derived Services (created after app launches)

    @State private var memoryMatcher: MemoryMatcher?

    // MARK: - Legacy Support

    /// Mock service for existing UI (HomeViewModel compatibility)
    private let contextService = MockContextService()

    // MARK: - App Body

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(contextService: contextService))
                .environmentObject(locationService)
                .environmentObject(photosService)
                .environmentObject(whisperEngine)
                .environmentObject(motionService)
                .task {
                    await initializeServices()
                }
        }
    }

    // MARK: - Service Initialization

    /// Initialize services in correct order after app launches
    @MainActor
    private func initializeServices() async {
        print("ContextualApp: Initializing services...")

        // 1. Create MemoryMatcher now that services exist
        let matcher = MemoryMatcher(
            locationService: locationService,
            photosService: photosService,
            whisperEngine: whisperEngine
        )
        memoryMatcher = matcher

        // 2. Request location permission
        if locationService.authorizationStatus == .notDetermined {
            locationService.requestAuthorization()
            try? await Task.sleep(nanoseconds: 500_000_000)
        }

        // 3. Request Photos permission
        let photosStatus = await photosService.requestAuthorization()
        print("ContextualApp: Photos authorization: \(photosStatus.rawValue)")

        // 4. Build photo spatial index if authorized
        if photosStatus == .authorized || photosStatus == .limited {
            await photosService.buildIndex()
            print("ContextualApp: Indexed \(photosService.indexedCount) photos")
        }

        // 5. Start location monitoring
        if locationService.authorizationStatus == .authorizedAlways ||
           locationService.authorizationStatus == .authorizedWhenInUse {
            locationService.start()
            print("ContextualApp: Location monitoring started")
        }

        // 6. Start memory matching
        matcher.startMonitoring()
        print("ContextualApp: Memory matcher started")

        print("ContextualApp: All services initialized")
    }
}
