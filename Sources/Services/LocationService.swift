//
//  LocationService.swift
//  Contextual
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate, ContextServiceProtocol {

    // MARK: - Singleton
    static let shared = LocationService()

    // MARK: - Private
    private let manager = CLLocationManager()
    private let stateSubject = CurrentValueSubject<MomentState, Never>(.quiet)

    // MARK: - ContextServiceProtocol requirement
    var statePublisher: AnyPublisher<MomentState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    // MARK: - Published properties
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastGateEvent: String?
    
    // MARK: - Callbacks for gate events
    var onGateEntry: ((String) -> Void)?
    var onGateExit: ((String) -> Void)?

    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Public API
    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    func registerGate(id: String, center: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let region = CLCircularRegion(center: center, radius: radius, identifier: id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
        print("📍 LocationService: Registered geofence '\(id)' at \(center.latitude), \(center.longitude)")
    }

    // MARK: - CLLocationManager Delegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            startUpdating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocation = loc

        // Fake moment-state inference for now
        updateStateBasedOnLocation(loc)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        lastGateEvent = "enter:\(circularRegion.identifier)"
        print("🚪 LocationService: Entered region '\(circularRegion.identifier)'")
        
        // Trigger callback to GateRuleEngine
        onGateEntry?(circularRegion.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        lastGateEvent = "exit:\(circularRegion.identifier)"
        print("🚶 LocationService: Exited region '\(circularRegion.identifier)'")
        
        // Trigger callback to GateRuleEngine
        onGateExit?(circularRegion.identifier)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("❌ LocationService: Monitoring failed for region: \(error.localizedDescription)")
    }

    // MARK: - State Logic (temporary placeholder)
    private func updateStateBasedOnLocation(_ location: CLLocation) {
        // Placeholder logic to feed HomeViewModel
        if location.horizontalAccuracy < 50 {
            stateSubject.send(.active("Nearby Context"))
        } else {
            stateSubject.send(.quiet)
        }
    }
}
