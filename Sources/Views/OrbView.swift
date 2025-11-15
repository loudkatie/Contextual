//
//  OrbView.swift
//

import SwiftUI

struct OrbView: View {
    var body: some View {
        VStack {
            Spacer()

            Image("orb_holo")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .shadow(color: .white.opacity(0.4), radius: 32)

            Text("listening...")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.black.opacity(0.4))
                .padding(.top, 12)

            Spacer()
        }
        .background(Color.white.opacity(0.97))
    }
}
