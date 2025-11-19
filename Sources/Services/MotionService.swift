//
//  MotionService.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation
import CoreMotion
import Combine

/// MotionService detects whether the user is walking, stationary, in a vehicle, etc.
/// Contextual uses this to tune whisper timing & suppress noise.
final class MotionService: NSObject, ObservableObject {

    enum MotionState: String {
        case unknown
        case stationary
        case walking
        case running
        case automotive
    }

    @Published var state: MotionState = .unknown

    private let activityManager = CMMotionActivityManager()
    private let queue = OperationQueue()

    override init() {
        super.init()
        // Don't auto-start - let onboarding trigger this
    }

    func startUpdates() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            state = .unknown
            return
        }

        activityManager.startActivityUpdates(to: queue) { [weak self] activity in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                self?.state = self?.mapActivity(activity) ?? .unknown
            }
        }
    }

    private func mapActivity(_ activity: CMMotionActivity) -> MotionState {
        if activity.walking { return .walking }
        if activity.running { return .running }
        if activity.automotive { return .automotive }
        if activity.stationary { return .stationary }
        return .unknown
    }
}
