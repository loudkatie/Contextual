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
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(Color(red: 0.46, green: 0.52, blue: 0.60))
                    .padding(.top, 60)

                Text("Permissions")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .kerning(0.5)

                Text("Contextual needs a few permissions to work its magic.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer().frame(height: 20)

            // Permissions List
            VStack(spacing: 16) {
                PermissionCard(
                    icon: "location.fill",
                    title: "Location (Always)",
                    description: "Detects when you enter meaningful places",
                    status: statusText(perms.locationAuth),
                    isGranted: perms.locationAuth == .authorizedAlways,
                    action: {
                        perms.requestLocationAlways()
                    }
                )

                PermissionCard(
                    icon: "figure.walk",
                    title: "Motion & Fitness",
                    description: "Understands when you're walking, standing, or in transit",
                    status: perms.motionAuthorized ? "Granted" : "Not Granted",
                    isGranted: perms.motionAuthorized,
                    action: {
                        perms.requestMotion()
                    }
                )
            }
            .padding(.horizontal, 24)

            Spacer()

            // Continue Button
            Button(action: { onDone?() }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        (perms.locationAuth == .authorizedAlways || perms.locationAuth == .authorizedWhenInUse)
                            ? Color.blue
                            : Color.gray.opacity(0.5),
                        in: Capsule()
                    )
            }
            .disabled(perms.locationAuth == .notDetermined)
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
    }

    private func statusText(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Granted"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Granted"
        case .authorizedWhenInUse: return "When In Use"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Permission Card

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let status: String
    let isGranted: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isGranted ? .green : .blue)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }

            HStack {
                Text(status)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isGranted ? .green : .secondary)

                Spacer()

                if !isGranted {
                    Button(action: action) {
                        Text("Grant")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue, in: Capsule())
                    }
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.5))
        )
    }
}

#Preview { PermissionsFlowView() }
