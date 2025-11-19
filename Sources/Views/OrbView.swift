//
//  OrbView.swift
//  Contextual
//
//  Immersive, ambient orb with dramatic presence.
//

import SwiftUI

struct OrbView: View {
    @State private var animate = false
    @State private var shimmer = false
    @State private var floaterOffsets: [(x: CGFloat, y: CGFloat)] = []
    
    var body: some View {
        ZStack {
            // Far outer atmosphere (massive glow)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.2),
                            Color.purple.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 100,
                        endRadius: 350
                    )
                )
                .frame(width: 700, height: 700)
                .blur(radius: 50)
                .scaleEffect(animate ? 1.2 : 0.85)
            
            // Mid atmosphere layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.blue.opacity(0.2),
                            Color.purple.opacity(0.12),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 120,
                        endRadius: 280
                    )
                )
                .frame(width: 560, height: 560)
                .blur(radius: 35)
                .scaleEffect(animate ? 1.15 : 0.88)
            
            // Main orb body (HUGE)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.65),
                            Color.blue.opacity(0.3),
                            Color.purple.opacity(0.2),
                            Color.white.opacity(0.08)
                        ],
                        center: UnitPoint(x: 0.4, y: 0.4),
                        startRadius: 60,
                        endRadius: 220
                    )
                )
                .frame(width: 440, height: 440)
                .blur(radius: 4)
                .scaleEffect(animate ? 1.12 : 0.90)
            
            // Soft inner glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .blur(radius: 20)
                .offset(x: -30, y: -30)
                .opacity(shimmer ? 0.9 : 0.5)
            
            // Magic floaters (more of them, random positions)
            ForEach(0..<12, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: CGFloat.random(in: 3...6), height: CGFloat.random(in: 3...6))
                    .blur(radius: 2)
                    .offset(
                        x: floaterOffsets.indices.contains(index) ? floaterOffsets[index].x : 0,
                        y: floaterOffsets.indices.contains(index) ? floaterOffsets[index].y : 0
                    )
                    .scaleEffect(shimmer ? 1.8 : 0.6)
                    .opacity(shimmer ? 1.0 : 0.3)
                    .animation(
                        Animation
                            .easeInOut(duration: Double.random(in: 2.5...4.0))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: shimmer
                    )
            }
        }
        .onAppear {
            // Generate random floater positions
            floaterOffsets = (0..<12).map { _ in
                (
                    x: CGFloat.random(in: -180...180),
                    y: CGFloat.random(in: -180...180)
                )
            }
            
            // Dramatic breathing animation
            withAnimation(
                Animation
                    .easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
            
            // Shimmer/floater animation
            withAnimation(
                Animation
                    .easeInOut(duration: 3.2)
                    .repeatForever(autoreverses: true)
            ) {
                shimmer = true
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color.purple.opacity(0.15),
                Color.purple.opacity(0.08),
                Color.purple.opacity(0.15)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        OrbView()
    }
}
