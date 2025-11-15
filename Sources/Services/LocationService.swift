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
