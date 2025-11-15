//
//  SplashView.swift
//  Contextual
//
//  Created by Katie Richman on 11/16/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.98).ignoresSafeArea()

            VStack(spacing: 28) {

                // MARK: Glyph
                Image("glyph_star")   // we will add this asset in a moment
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .opacity(0.9)

                // MARK: Wordmark
                Text("contextual")
                    .kerning(4.0)                         // WIDE
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Color(red: 0.46, green: 0.52, blue: 0.60)) // soft holographic silver

                Spacer().frame(height: 40)

                // MARK: Orb
                Image("orb_holo")        // your selected orb
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .shadow(color: .white.opacity(0.4), radius: 40, x: 0, y: 0)
            }
        }
    }
}
