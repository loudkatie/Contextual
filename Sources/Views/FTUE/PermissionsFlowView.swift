//
//  PermissionsFlowView.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import SwiftUI
import CoreLocation
import CoreMotion

struct PermissionsFlowView: View {
    @StateObject private var perms = PermissionsManager.shared
    var onDone: (() -> Void)?

    var body: some View {
        List {
            Section("Location") {
                HStack {
                    Text("Authorization")
                    Spacer()
                    Text(description(perms.locationAuth))
                        .foregroundColor(.secondary)
                }
                Button("Grant Location (Always)") {
                    perms.requestLocationAlways()
                }
            }

            Section("Motion") {
                HStack {
                    Text("Status")
                    Spacer()
                    Text(perms.motionAuthorized ? "Authorized" : "Not Authorized")
                        .foregroundColor(.secondary)
                }
                Button("Grant Motion") {
                    perms.requestMotion()
                }
            }

            Section("Notifications (optional)") {
                Text("You can enable later in Settings.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Permissions")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { onDone?() }
            }
        }
    }

    private func description(_ status: CLAuthorizationStatus) -> String {
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

#Preview { PermissionsFlowView() }
