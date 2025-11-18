//
//  GateRuleEngine.swift
//  Contextual
//
//  Created by Loud Labs Team
//  Copyright © 2025 Loud Labs. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

/// GateRuleEngine manages geofences and generates whispers when users enter/exit gates.
final class GateRuleEngine: ObservableObject {
    
    // MARK: - Published State
    
    @Published var activeRoute: DemoRoute = .sanCarlos
    
    // MARK: - Dependencies
    
    private let locationService: LocationService
    private let whisperEngine: WhisperEngine
    
    // MARK: - Demo Routes
    
    enum DemoRoute: String, CaseIterable {
        case sanCarlos = "San Carlos (Testing)"
        case paloAlto = "Palo Alto + Stanford (Demo)"
    }
    
    // MARK: - Geofence Definitions
    
    private let sanCarlosGates: [(id: String, lat: Double, lon: Double, radius: Double)] = [
        (id: "starbucks_sancarlos", lat: 37.5062, lon: -122.2606, radius: 50),
        (id: "laurelstreet_sancarlos", lat: 37.5074, lon: -122.2604, radius: 75),
        (id: "walgreens_sancarlos", lat: 37.5102, lon: -122.2638, radius: 50)
    ]
    
    private let paloAltoGates: [(id: String, lat: Double, lon: Double, radius: Double)] = [
        (id: "bluebottle_paloalto", lat: 37.4459, lon: -122.1605, radius: 50),
        (id: "walgreens_paloalto", lat: 37.4475, lon: -122.1598, radius: 50),
        (id: "coupa_stanford", lat: 37.4287, lon: -122.1697, radius: 75)
    ]
    
    // MARK: - Whisper Scripts
    
    private let whisperScripts: [String: String] = [
        "starbucks_sancarlos": "You have 10 minutes free. Want to grab coffee?",
        "laurelstreet_sancarlos": "You took a photo here last month. Want me to show you?",
        "walgreens_sancarlos": "You have $7 off expiring today. Want to use it?",
        "bluebottle_paloalto": "You're free for 15 minutes. Want to grab coffee?",
        "walgreens_paloalto": "You have $7 off expiring today. Want to use it?",
        "coupa_stanford": "You took notes here last spring. Want me to surface them?"
    ]
    
    // MARK: - Initialization
    
    init(locationService: LocationService, whisperEngine: WhisperEngine) {
        self.locationService = locationService
        self.whisperEngine = whisperEngine
        
        registerGeofences(for: activeRoute)
    }
    
    // MARK: - Public Interface
    
    func switchRoute(to route: DemoRoute) {
        print("📍 GateRuleEngine: Switching to route: \(route.rawValue)")
        activeRoute = route
        registerGeofences(for: route)
    }
    
    func handleGateEntry(gateId: String) {
        print("🚪 GateRuleEngine: Entered gate: \(gateId)")
        
        guard let whisperText = whisperScripts[gateId] else {
            print("⚠️ GateRuleEngine: No whisper script found for gate: \(gateId)")
            return
        }
        
        let category = categoryForGate(gateId: gateId)
        whisperEngine.speak(text: whisperText, category: category)
    }
    
    func handleGateExit(gateId: String) {
        print("🚶 GateRuleEngine: Exited gate: \(gateId)")
    }
    
    // MARK: - Private Helpers
    
    private func registerGeofences(for route: DemoRoute) {
        let gates = route == .sanCarlos ? sanCarlosGates : paloAltoGates
        
        print("📍 GateRuleEngine: Registering \(gates.count) geofences")
        
        for gate in gates {
            let coordinate = CLLocationCoordinate2D(latitude: gate.lat, longitude: gate.lon)
            locationService.registerGate(
                id: gate.id,
                center: coordinate,
                radius: gate.radius
            )
        }
    }
    
    private func categoryForGate(gateId: String) -> String {
        if gateId.contains("walgreens") {
            return "loyalty"
        } else if gateId.contains("starbucks") || gateId.contains("bluebottle") {
            return "opportunity"
        } else if gateId.contains("laurel") || gateId.contains("coupa") {
            return "memory"
        } else {
            return "general"
        }
    }
}
