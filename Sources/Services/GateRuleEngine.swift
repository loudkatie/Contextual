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
        case paloAlto = "Palo Alto + Stanford"
        case sanFrancisco = "San Francisco"
        case newYork = "New York City"
        case losAngeles = "Los Angeles"
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

    private let sanFranciscoGates: [(id: String, lat: Double, lon: Double, radius: Double)] = [
        (id: "bluebottle_mission", lat: 37.7611, lon: -122.4194, radius: 50),
        (id: "dolores_park", lat: 37.7596, lon: -122.4269, radius: 100),
        (id: "tartine_bakery", lat: 37.7613, lon: -122.4239, radius: 50),
        (id: "ritual_coffee", lat: 37.7628, lon: -122.4213, radius: 50)
    ]

    private let newYorkGates: [(id: String, lat: Double, lon: Double, radius: Double)] = [
        (id: "devocion_williamsburg", lat: 40.7182, lon: -73.9571, radius: 50),
        (id: "washington_square_park", lat: 40.7308, lon: -73.9973, radius: 100),
        (id: "highline_chelsea", lat: 40.7480, lon: -74.0048, radius: 75),
        (id: "thinking_cup_uws", lat: 40.7858, lon: -73.9764, radius: 50)
    ]

    private let losAngelesGates: [(id: String, lat: Double, lon: Double, radius: Double)] = [
        (id: "intelligentsia_venice", lat: 33.9906, lon: -118.4664, radius: 50),
        (id: "abbot_kinney", lat: 33.9925, lon: -118.4674, radius: 75),
        (id: "silverlake_reservoir", lat: 34.0949, lon: -118.2706, radius: 100),
        (id: "groundwork_dtla", lat: 34.0455, lon: -118.2490, radius: 50)
    ]
    
    // MARK: - Whisper Scripts

    private let whisperScripts: [String: [String]] = [
        "starbucks_sancarlos": [
            "You have 10 minutes free. Want to grab coffee?",
            "You're near Starbucks. Sarah mentioned coffee tomorrow - want to invite her now?",
            "Quick break? You haven't had caffeine since 7am."
        ],
        "laurelstreet_sancarlos": [
            "You took a photo here last month. Want me to show you?",
            "Last time you were here, you thought about that idea for Katie. Still relevant?",
            "This is where you walked Max every morning. Miss him?"
        ],
        "walgreens_sancarlos": [
            "You have $7 off expiring today. Want to use it?",
            "Walgreens. Your prescription might be ready. Want me to check?",
            "Quick errand? You're out of contact solution."
        ],
        "bluebottle_paloalto": [
            "You're free for 15 minutes. Want to grab coffee?",
            "Blue Bottle. That email to Joe can wait - decompress for 10?",
            "You mentioned trying their cold brew. Now's the time."
        ],
        "walgreens_paloalto": [
            "You have $7 off expiring today. Want to use it?",
            "Walgreens. You added toothpaste to your list last week.",
            "Quick stop? You're low on ibuprofen."
        ],
        "coupa_stanford": [
            "You took notes here last spring. Want me to surface them?",
            "Coupa. Your calendar shows 20 minutes until next meeting. Coffee run?",
            "This is where you had that breakthrough on the pitch deck. Feeling inspired?"
        ],

        // San Francisco
        "bluebottle_mission": [
            "Blue Bottle. 15 minutes until your call. Want to decompress?",
            "You mentioned trying their New Orleans iced coffee. Now's your chance.",
            "Quick caffeine break? You've been heads-down for 3 hours."
        ],
        "dolores_park": [
            "Dolores Park. Perfect weather to take that call outside.",
            "You walked here after great news last time. What's today's occasion?",
            "20 minutes of sun before your next meeting. Doctor's orders."
        ],
        "tartine_bakery": [
            "Tartine. That morning bun you've been thinking about is waiting.",
            "You're near Tartine. Grab a croissant and people-watch for 10?",
            "Early enough to beat the line. Treat yourself?"
        ],
        "ritual_coffee": [
            "Ritual. You have 18 minutes free. Coffee and a reset?",
            "You mentioned their single-origin pour-over. Time to try it.",
            "Quick break? You haven't moved from your desk in 4 hours."
        ],

        // New York
        "devocion_williamsburg": [
            "Devoción. You're early for drinks with Sam - coffee first?",
            "Beautiful space for that Zoom call in 15 minutes.",
            "You mentioned their cold brew. Now or never."
        ],
        "washington_square_park": [
            "Washington Square Park. Take your call outside?",
            "You sat here when you needed to think through the last big decision. Need clarity now?",
            "15 minutes until your next thing. Fresh air helps."
        ],
        "highline_chelsea": [
            "The High Line. Walk and think for 10 minutes?",
            "You're near the High Line. Clear your head before the meeting?",
            "Perfect afternoon for a quick stroll. You've earned it."
        ],
        "thinking_cup_uws": [
            "Thinking Cup. That email can wait - grab a latte?",
            "You're near Thinking Cup. 12 minutes until your call.",
            "Quick caffeine stop? You've been running since 7am."
        ],

        // Los Angeles
        "intelligentsia_venice": [
            "Intelligentsia. You have time for that cortado.",
            "You're near Intelligentsia. Grab coffee before the beach walk?",
            "Perfect spot for your 2pm call. Better than a hot car."
        ],
        "abbot_kinney": [
            "Abbot Kinney. You mentioned wanting to check out that new shop.",
            "You're on Abbot Kinney with 20 minutes free. Wander?",
            "Perfect afternoon to walk and decompress. You've been grinding."
        ],
        "silverlake_reservoir": [
            "Silver Lake Reservoir. Take that call while you walk?",
            "You ran here every morning last year. Miss it?",
            "Beautiful afternoon for a loop around the reservoir."
        ],
        "groundwork_dtla": [
            "Groundwork. Grab an iced coffee before heading back?",
            "You're near Groundwork with 15 minutes to spare.",
            "Quick caffeine break? Downtown traffic isn't going anywhere."
        ]
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

        guard let whisperOptions = whisperScripts[gateId], !whisperOptions.isEmpty else {
            print("⚠️ GateRuleEngine: No whisper script found for gate: \(gateId)")
            return
        }

        // Randomly select a whisper from available options
        let whisperText = whisperOptions.randomElement()!

        let category = categoryForGate(gateId: gateId)
        whisperEngine.speak(text: whisperText, category: category)
    }
    
    func handleGateExit(gateId: String) {
        print("🚶 GateRuleEngine: Exited gate: \(gateId)")
    }
    
    // MARK: - Private Helpers

    private func registerGeofences(for route: DemoRoute) {
        let gates: [(id: String, lat: Double, lon: Double, radius: Double)]

        switch route {
        case .sanCarlos:
            gates = sanCarlosGates
        case .paloAlto:
            gates = paloAltoGates
        case .sanFrancisco:
            gates = sanFranciscoGates
        case .newYork:
            gates = newYorkGates
        case .losAngeles:
            gates = losAngelesGates
        }

        print("📍 GateRuleEngine: Registering \(gates.count) geofences for \(route.rawValue)")

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
        // Loyalty: stores with rewards/benefits
        if gateId.contains("walgreens") {
            return "loyalty"
        }
        // Opportunity: coffee shops, quick stops
        else if gateId.contains("starbucks") || gateId.contains("bluebottle") ||
                gateId.contains("ritual") || gateId.contains("devocion") ||
                gateId.contains("thinking") || gateId.contains("intelligentsia") ||
                gateId.contains("groundwork") || gateId.contains("tartine") {
            return "opportunity"
        }
        // Memory: places with personal history
        else if gateId.contains("laurel") || gateId.contains("coupa") ||
                gateId.contains("reservoir") {
            return "memory"
        }
        // Discovery: parks, neighborhoods, exploration
        else if gateId.contains("park") || gateId.contains("highline") ||
                gateId.contains("abbot") {
            return "discovery"
        }
        else {
            return "general"
        }
    }
}
