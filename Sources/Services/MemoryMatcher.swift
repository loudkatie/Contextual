//
//  MemoryMatcher.swift
//  Contextual
//
//  Bridges LocationService and PhotosService to trigger memory whispers.
//

import Foundation
import CoreLocation
import Combine

/// MemoryMatcher detects when user enters locations with photo memories
/// and orchestrates the whisper delivery.
@MainActor
final class MemoryMatcher: ObservableObject {

    // MARK: - Published State

    /// Currently matched memories at user's location
    @Published var currentMemories: [MemoryAsset] = []

    /// Location where last match occurred
    @Published var lastMatchLocation: CLLocation?

    /// When last match occurred
    @Published var lastMatchDate: Date?

    /// Whether actively monitoring for matches
    @Published var isMonitoring: Bool = false

    // MARK: - Dependencies

    private let locationService: LocationService
    private let photosService: PhotosService
    private let whisperEngine: WhisperEngine

    // MARK: - Private State

    private var locationCancellable: AnyCancellable?

    /// Tracks locations where we've already whispered today (rate limiting)
    /// Key: location hash, Value: date of last whisper
    private var whisperedLocations: [String: Date] = [:]

    /// Search radius for memory matching (meters)
    private let matchRadius: CLLocationDistance = 50

    /// Minimum distance from last match to trigger new check (meters)
    private let minimumMovementDistance: CLLocationDistance = 30

    // MARK: - Initialization

    init(
        locationService: LocationService,
        photosService: PhotosService,
        whisperEngine: WhisperEngine
    ) {
        self.locationService = locationService
        self.photosService = photosService
        self.whisperEngine = whisperEngine
    }

    // MARK: - Monitoring

    /// Start monitoring location changes for memory matches
    func startMonitoring() {
        guard !isMonitoring else { return }

        isMonitoring = true

        // Subscribe to location updates
        locationCancellable = locationService.$currentLocation
            .compactMap { $0 }  // Filter nil locations
            .removeDuplicates { old, new in
                // Only process if moved significantly
                old.distance(from: new) < self.minimumMovementDistance
            }
            .sink { [weak self] location in
                Task { @MainActor in
                    await self?.checkForMemories(at: location)
                }
            }

        print("MemoryMatcher: Started monitoring")
    }

    /// Stop monitoring location changes
    func stopMonitoring() {
        locationCancellable?.cancel()
        locationCancellable = nil
        isMonitoring = false
        print("MemoryMatcher: Stopped monitoring")
    }

    // MARK: - Core Logic

    /// Check if user has memories at current location
    private func checkForMemories(at location: CLLocation) async {
        // Quick check first (no asset fetching)
        guard photosService.hasMemories(near: location, radius: matchRadius) else {
            return
        }

        // Rate limit: have we whispered at this location today?
        guard !hasWhisperedAtLocation(location) else {
            print("MemoryMatcher: Skipping - already whispered at this location today")
            return
        }

        // Fetch full memory list
        let memories = photosService.findMemories(near: location, radius: matchRadius)

        guard !memories.isEmpty else { return }

        // Update state
        currentMemories = memories
        lastMatchLocation = location
        lastMatchDate = Date()

        // Handle the match
        await handleMemoryMatch(memories, at: location)
    }

    /// Process a memory match and trigger whisper
    private func handleMemoryMatch(_ memories: [MemoryAsset], at location: CLLocation) async {
        // Generate whisper script
        let script = generateWhisperScript(for: memories)

        // Mark location as whispered
        markLocationWhispered(location)

        // Trigger whisper via WhisperEngine
        whisperEngine.speak(script)

        print("MemoryMatcher: Triggered whisper for \(memories.count) memories")
    }

    // MARK: - Whisper Script Generation

    /// Generate natural language whisper script based on memories
    /// Target: under 30 words (~3 seconds spoken)
    private func generateWhisperScript(for memories: [MemoryAsset]) -> String {
        let count = memories.count

        // Get the most representative timeframe
        let timeframe = dominantTimeframe(for: memories)

        // Singular vs plural
        let memoryWord = count == 1 ? "memory" : "memories"
        let seeWord = count == 1 ? "it" : "them"

        return "You captured \(count) \(memoryWord) here \(timeframe). Want to see \(seeWord)?"
    }

    /// Determine the most representative timeframe for a set of memories
    private func dominantTimeframe(for memories: [MemoryAsset]) -> String {
        guard let oldest = memories.min(by: { $0.captureDate < $1.captureDate }),
              let newest = memories.max(by: { $0.captureDate < $1.captureDate }) else {
            return "a while ago"
        }

        // If all from same season, use season description
        if oldest.seasonDescription == newest.seasonDescription {
            let year = Calendar.current.component(.year, from: oldest.captureDate)
            let currentYear = Calendar.current.component(.year, from: Date())

            if year == currentYear {
                return "this \(oldest.seasonDescription)"
            } else if year == currentYear - 1 {
                return "last \(oldest.seasonDescription)"
            } else {
                return "\(oldest.seasonDescription) \(year)"
            }
        }

        // Otherwise use relative time of oldest
        return oldest.timeDescription
    }

    // MARK: - Rate Limiting

    /// Generate a hash for a location (groups nearby coordinates)
    private func locationHash(for location: CLLocation) -> String {
        // Round to ~100m precision for grouping
        let latHash = Int(floor(location.coordinate.latitude * 1000))
        let lonHash = Int(floor(location.coordinate.longitude * 1000))
        return "\(latHash)_\(lonHash)"
    }

    /// Check if we've already whispered at this location today
    private func hasWhisperedAtLocation(_ location: CLLocation) -> Bool {
        let hash = locationHash(for: location)

        guard let lastWhisper = whisperedLocations[hash] else {
            return false
        }

        // Check if it was today
        return Calendar.current.isDateInToday(lastWhisper)
    }

    /// Mark a location as whispered
    private func markLocationWhispered(_ location: CLLocation) {
        let hash = locationHash(for: location)
        whisperedLocations[hash] = Date()

        // Cleanup old entries (older than 24 hours)
        let cutoff = Date().addingTimeInterval(-24 * 60 * 60)
        whisperedLocations = whisperedLocations.filter { $0.value > cutoff }
    }

    // MARK: - Manual Trigger (for testing/debug)

    /// Manually check for memories at a specific location
    func manualCheck(at location: CLLocation) async -> [MemoryAsset] {
        let memories = photosService.findMemories(near: location, radius: matchRadius)
        currentMemories = memories
        return memories
    }

    /// Clear rate limit state (for testing)
    func clearRateLimitState() {
        whisperedLocations.removeAll()
    }
}
