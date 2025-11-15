//
//  ContentView.swift
//  Contextual
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 32) {
            OrbView()
                .frame(width: 140, height: 140)

            Text("Listening…")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary.opacity(0.6))

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ContentView()
}
