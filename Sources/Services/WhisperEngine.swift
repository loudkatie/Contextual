//
//  WhisperEngine.swift
//  Contextual
//

import Foundation
import AVFoundation
import Combine

final class WhisperEngine: ObservableObject {

    static let shared = WhisperEngine()

    private var audioPlayer: AVAudioPlayer?
    private var cancellables = Set<AnyCancellable>()

    private let queue = DispatchQueue(label: "contextual.whisper.engine")

    // MARK: - Public Trigger API
    func trigger(_ candidate: WhisperCandidate) {
        // 👇 NEW LINE YOU ASKED FOR
        print("[WhisperEngine] Candidate triggered:", candidate)

        queue.async { [weak self] in
            self?.playSound(named: "whisper-default")
        }
    }

    // MARK: - Private playback handler
    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("[WhisperEngine] ERROR — sound not found:", name)
            return
        }

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()

            print("[WhisperEngine] Playing:", name)

        } catch {
            print("[WhisperEngine] Playback error:", error.localizedDescription)
        }
    }
}

