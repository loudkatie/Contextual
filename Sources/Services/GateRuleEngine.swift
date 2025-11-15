//
//  GateRuleEngine.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import Foundation
import CoreLocation
import Combine

final class GateRuleEngine: NSObject, ObservableObject {
    enum Gate: String, CaseIterable, Identifiable {
        case blueBottle, appleStore, stanfordOval
        var id: String { rawValue }
    }

    @Published private(set) var lastTriggered: Gate?
    private var cancellables = Set<AnyCancellable>()

    override init() { super.init() }

    // Stub: simulate a trigger for demo/testing
    func simulateTrigger(_ gate: Gate) {
        lastTriggered = gate
    }

    // Future: start monitoring geofences and route to WhisperEngine
    func start() {}
    func stop() {}
}
