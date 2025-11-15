//
//  HomeView.swift
//  ContextualOS
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 32) {

            Text("Contextual")
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.top, 48)

            OrbView()
                .frame(width: 160, height: 160)

            MomentText(state: viewModel.state)
                .padding(.horizontal, 32)

            if let action = viewModel.primaryAction {
                PrimaryButton(title: action.title, action: action.handler)
                    .padding(.top, 12)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - ViewModel

final class HomeViewModel: ObservableObject {
    @Published var state: MomentState = .quiet

    struct MomentAction {
        let title: String
        let handler: () -> Void
    }

    @Published var primaryAction: MomentAction? = nil

    private var cancellables = Set<AnyCancellable>()

    init(contextService: ContextServiceProtocol) {
        contextService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (newState: MomentState) in
                self?.state = newState
                self?.configureAction(for: newState)
            }
            .store(in: &cancellables)
    }

    private func configureAction(for state: MomentState) {
        switch state {
        case .quiet:
            primaryAction = nil

        case .approaching(let label):
            primaryAction = MomentAction(title: "View") {
                print("Tapped View for \(label)")
            }

        case .active(let label):
            primaryAction = MomentAction(title: "Open") {
                print("Tapped Open for \(label)")
            }

        case .resolved:
            primaryAction = nil
        }
    }
}
