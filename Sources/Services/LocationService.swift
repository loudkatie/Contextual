//
//  LocationService.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation
import CoreLocation
import Combine

/// Lightweight location manager for Contextual.
/// Uses region monitoring + significant location changes to preserve battery.
final class LocationService: NSObject, ObservableObject {

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var lastGateEvent: String?   // debug surface only

    private let manager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.pausesLocationUpdatesAutomatically = true
        manager.allowsBackgroundLocationUpdates = true

        requestAuthorization()
    }

    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func start() {
        manager.startMonitoringSignificantLocationChanges()
    }

    func stop() {
        manager.stopMonitoringSignificantLocationChanges()
    }

    /// Registers a circular geofence.
    func registerGate(id: String, center: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let region = CLCircularRegion(center: center,
                                      radius: radius,
                                      identifier: id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedAlways {
            start()
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocation = loc
    }

    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        lastGateEvent = "enter:\(region.identifier)"
    }

    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
        lastGateEvent = "exit:\(region.identifier)"
    }

    func locationManager(_ manager: CLLocationManager,
                         monitoringDidFailFor region: CLRegion?,
                         withError error: Error) {
        print("Gate monitoring failed:", error.localizedDescription)
    }
}
