//
//  OrbView.swift
//

import SwiftUI

struct OrbView: View {
    let state: MomentState
    @State private var animate = false

    var body: some View {
        Circle()
            .fill(Color(.systemGray5))
            .overlay(
                Circle()
                    .stroke(Color(.systemGray3), lineWidth: 1)
            )
            .shadow(color: shadowColor, radius: animate ? 16 : 4)
            .opacity(animate ? 0.9 : 0.6)
            .scaleEffect(animate ? 1.03 : 0.97)
            .animation(
                Animation.easeInOut(duration: 2.2).repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear { animate = true }
    }

    private var shadowColor: Color {
        switch state {
        case .quiet: return Color.black.opacity(0.08)
        case .approaching: return Color.blue.opacity(0.12)
        case .active: return Color.blue.opacity(0.18)
        case .resolved: return Color.black.opacity(0.04)
        }
    }
}
