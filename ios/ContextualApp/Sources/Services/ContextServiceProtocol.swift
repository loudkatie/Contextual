//
//  ContextServiceProtocol.swift
//

import Foundation
import Combine

protocol ContextServiceProtocol {
    var statePublisher: AnyPublisher<MomentState, Never> { get }
}//
//  ContextServiceProtocol.swift
//  Contextual
//
//  Created by Katie Richman on 11/14/25.
//

