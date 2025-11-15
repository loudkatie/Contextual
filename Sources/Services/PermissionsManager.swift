//
//  PermissionsManager.swift
//  Contextual
//
//  Created by Katie Richman on 11/17/25.
//

import Foundation
import Combine
import CoreLocation
import CoreMotion

final class PermissionsManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = PermissionsManager()

    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()

    @Published var locationAuth: CLAuthorizationStatus = .notDetermined
    @Published var motionAuthorized: Bool = false

    override private init() {
        super.init()
        locationManager.delegate = self
        locationAuth = locationManager.authorizationStatus
    }

    // MARK: - Location
    func requestLocationAlways() {
        // Ask When In Use first, then upgrade to Always
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuth = manager.authorizationStatus
        // If already when-in-use, try to upgrade to always once
        if locationAuth == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
    }

    // MARK: - Motion
    func requestMotion() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            motionAuthorized = false
            return
        }
        // A call to queryPastActivity prompts for permission if needed.
        let now = Date()
        motionManager.queryActivityStarting(from: now.addingTimeInterval(-60),
                                            to: now,
                                            to: .main) { _, _ in
            self.motionAuthorized = (CMMotionActivityManager.authorizationStatus() == .authorized)
        }
    }
}

