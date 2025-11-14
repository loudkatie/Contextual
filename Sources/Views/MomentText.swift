//
//  MomentText.swift
//

import SwiftUI

struct MomentText: View {
    let state: MomentState

    var body: some View {
        Text(state.displayText)
            .font(.system(size: 22, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
    }
}
