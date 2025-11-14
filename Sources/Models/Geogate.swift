//
//  Geogate.swift
//  
//
//  Created by Katie Richman on 11/14/25.
//

import Foundation
import CoreLocation

/// Represents a geofence that may trigger a whisper.
struct Geogate: Identifiable {
    let id: String
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let category: Category

    enum Category: String {
        case home
        case work
        case restaurant
        case store
        case memory
        case social
    }
}
