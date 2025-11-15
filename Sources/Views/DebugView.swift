//
//  DebugView.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import SwiftUI
import CoreLocation
internal import _LocationEssentials

/// A simple developer-facing view for inspecting live app state.
struct DebugView: View {

    @EnvironmentObject var location: LocationService
    @EnvironmentObject var motion: MotionService
    @EnvironmentObject var whisper: WhisperEngine

    var body: some View {
        List {
            Section(header: Text("Location")) {
                Text("Authorization: \(authorizationDescription(location.authorizationStatus))")

                if let loc = location.currentLocation {
                    Text("Lat: \(loc.coordinate.latitude)")
                    Text("Lon: \(loc.coordinate.longitude)")
                } else {
                    Text("Current Location: —")
                }

                if let event = location.lastGateEvent {
                    Text("Last Gate Event: \(event)")
                } else {
                    Text("Last Gate Event: —")
                }
            }

            Section(header: Text("Motion")) {
                Text("State: \(motion.state.rawValue)")
            }

            Section(header: Text("Whisper Engine")) {
                Text("Last Whisper: —")
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
        case .authorizedAlways: return "Authorized Always"
        case .authorizedWhenInUse: return "Authorized When In Use"
        @unknown default: return "Unknown"
        }
    }
}

