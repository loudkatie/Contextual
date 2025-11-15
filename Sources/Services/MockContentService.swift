//
//  MockContextService.swift
//

import Foundation
import Combine

final class MockContextService: ContextServiceProtocol {
    private let subject = CurrentValueSubject<MomentState, Never>(.quiet)

    var statePublisher: AnyPublisher<MomentState, Never> {
        subject.eraseToAnyPublisher()
    }

    // debugging helper
    func simulate(_ state: MomentState) {
        subject.send(state)
    }
}
