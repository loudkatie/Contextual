//
//  DebugView.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import SwiftUI
internal import _LocationEssentials

/// A simple developer-facing view for inspecting live app state.
struct DebugView: View {

    @EnvironmentObject var location: LocationService
    @EnvironmentObject var motion: MotionService
    @EnvironmentObject var whisper: WhisperEngine

    var body: some View {
        List {
            Section(header: Text("Location")) {
                Text("Authorization: \(location.authorizationStatus.description)")
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
                Text("Last Whisper: \(whisper.lastWhisper ?? "—")")
            }
        }
        .navigationTitle("Debug Tools")
    }
}
