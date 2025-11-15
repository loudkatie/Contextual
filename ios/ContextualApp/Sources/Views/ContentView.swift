//
//  ContentView.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import SwiftUI
import CoreLocation

/// Minimal UI shell for Contextual.
/// Shows system status + link to debug tools.
struct ContentView: View {

    @EnvironmentObject var location: LocationService
    @EnvironmentObject var motion: MotionService
    @EnvironmentObject var whisper: WhisperEngine

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                Text("Contextual")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                VStack(spacing: 12) {
                    statusRow(label: "Location", value: "\(location.authorizationStatus.description)")
                    statusRow(label: "Motion", value: motion.state.rawValue.capitalized)
                    statusRow(label: "Last Whisper", value: whisper.lastWhisper ?? "—")
                }

                NavigationLink("Open Debug Tools") {
                    DebugView()
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
    }

    private func statusRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Always"
        case .authorizedWhenInUse: return "When In Use"
        @unknown default: return "Unknown"
        }
    }
}
