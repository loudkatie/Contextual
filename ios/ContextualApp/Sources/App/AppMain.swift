//
//  AppMain.swift
//

import SwiftUI

@main
struct ContextualApp: App {

    // 1. Use the temporary mock service
    private let contextService = MockContextService()

    // 2. Create the HomeViewModel and inject the mock service
    private let homeViewModel: HomeViewModel

    init() {
        self.homeViewModel = HomeViewModel(contextService: contextService)
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
