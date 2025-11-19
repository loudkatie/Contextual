//
//  DebugView.swift
//
//
//  Created by Katie Richman on 11/14/25.
//

import SwiftUI
import CoreLocation
internal import _LocationEssentials

/// A developer-facing view for inspecting live app state and diagnostics.
struct DebugView: View {

    @EnvironmentObject var location: LocationService
    @EnvironmentObject var motion: MotionService
    @EnvironmentObject var whisper: WhisperEngine
    @EnvironmentObject var gateEngine: GateRuleEngine

    var body: some View {
        List {
            Section(header: Text("Active Route")) {
                Text("Route: \(gateEngine.activeRoute.rawValue)")
                    .font(.system(size: 14, weight: .medium))

                ForEach(GateRuleEngine.DemoRoute.allCases, id: \.self) { route in
                    Button(action: {
                        gateEngine.switchRoute(to: route)
                    }) {
                        HStack {
                            Text(route.rawValue)
                            Spacer()
                            if route == gateEngine.activeRoute {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }

            Section(header: Text("Location")) {
                HStack {
                    Text("Authorization")
                    Spacer()
                    Text(authorizationDescription(location.authorizationStatus))
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                }

                if let loc = location.currentLocation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Latitude: \(String(format: "%.6f", loc.coordinate.latitude))")
                            .font(.system(size: 13, design: .monospaced))
                        Text("Longitude: \(String(format: "%.6f", loc.coordinate.longitude))")
                            .font(.system(size: 13, design: .monospaced))
                        Text("Accuracy: ±\(Int(loc.horizontalAccuracy))m")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Current Location: Not Available")
                        .foregroundColor(.secondary)
                }

                if let event = location.lastGateEvent {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Gate Event")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text(event)
                            .font(.system(size: 13, design: .monospaced))
                    }
                } else {
                    Text("Last Gate Event: None")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Motion")) {
                HStack {
                    Text("State")
                    Spacer()
                    Text(motion.state.rawValue)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Whisper Engine")) {
                HStack {
                    Text("Is Whispering")
                    Spacer()
                    Text(whisper.isWhispering ? "Yes" : "No")
                        .foregroundColor(whisper.isWhispering ? .green : .secondary)
                        .font(.system(size: 13, weight: .semibold))
                }

                if let transcript = whisper.lastTranscript {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Whisper")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text("\"\(transcript)\"")
                            .font(.system(size: 13))
                            .italic()
                    }
                } else {
                    Text("Last Whisper: None")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Quick Actions")) {
                Button("Simulate Starbucks Entry") {
                    location.onGateEntry?("starbucks_sancarlos")
                }

                Button("Simulate Blue Bottle Entry") {
                    location.onGateEntry?("bluebottle_paloalto")
                }

                Button("Simulate Walgreens Entry") {
                    location.onGateEntry?("walgreens_sancarlos")
                }
            }
        }
        .navigationTitle("Debug Tools")
    }

    // MARK: - Helpers
    private func authorizationDescription(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Always"
        case .authorizedWhenInUse: return "When In Use"
        @unknown default: return "Unknown"
        }
    }
}

