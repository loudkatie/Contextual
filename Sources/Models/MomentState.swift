//
//  MomentState.swift
//

import Foundation

enum MomentState: Equatable {
    case quiet
    case approaching(String)   // approaching a geo gate or contextual moment
    case active(String)        // moment activated
    case resolved              // moment resolved

    var displayText: String {
        switch self {
        case .quiet:
            return "Everything is quiet.\nListening."

        case .approaching(let label):
            return "You're approaching\n\(label)."

        case .active(let label):
            return "\(label)\nis active now."

        case .resolved:
            return "All set."
        }
    }
}
