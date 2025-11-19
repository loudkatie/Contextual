//
//  SplashView.swift
//  Contextual
//
//  Created by Katie Richman on 11/16/25.
//

import SwiftUI

struct SplashView: View {
    @State private var glowIntensity: Double = 0.6

    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.96, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {

                // MARK: Glyph (sparkle icon)
                Image(systemName: "sparkles")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.20, blue: 0.35))

                // MARK: Wordmark
                Text("contextual")
                    .kerning(4.0)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.20, blue: 0.35))

                Spacer().frame(height: 60)

                // MARK: Simplified Orb
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.blue.opacity(0.15),
                                    Color.purple.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 60,
                                endRadius: 180
                            )
                        )
                        .frame(width: 360, height: 360)
                        .blur(radius: 30)
                        .opacity(glowIntensity)

                    // Main orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.2),
                                    Color.white.opacity(0.1)
                                ],
                                center: UnitPoint(x: 0.4, y: 0.4),
                                startRadius: 40,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .blur(radius: 2)

                    // Inner highlight
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .blur(radius: 15)
                        .offset(x: -20, y: -20)
                }
                .frame(width: 240, height: 240)
            }
        }
        .onAppear {
            // Gentle breathing animation - let it breathe
            withAnimation(
                Animation
                    .easeInOut(duration: 3.5)
                    .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.0
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Allow tap to skip (hidden affordance)
        }
    }
}
