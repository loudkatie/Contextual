//
//  PrimaryButton.swift
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .padding(.vertical, 14)
                .padding(.horizontal, 48)
                .background(Color(.systemGray5))
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
