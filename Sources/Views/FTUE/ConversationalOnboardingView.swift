//
//  ConversationalOnboardingView.swift
//  Contextual
//
//  Conversational chat-based onboarding with the orb as guide
//

import SwiftUI
import CoreLocation
import Photos

struct ConversationalOnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("onboardingSession") private var currentSession: Int = 1
    @AppStorage("userName") private var userName: String = ""

    @StateObject private var perms = PermissionsManager.shared
    @EnvironmentObject var whisperEngine: WhisperEngine

    @State private var messages: [OnboardingMessage] = []
    @State private var userInput: String = ""
    @State private var isOrbGlowing: Bool = false
    @State private var conversationStep: Int = 0
    @State private var awaitingUserInput: Bool = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.96, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Orb at top (like chat avatar)
                OrbView()
                    .frame(width: 120, height: 120)
                    .scaleEffect(isOrbGlowing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isOrbGlowing)
                    .padding(.top, 60)
                    .padding(.bottom, 30)

                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message, onPermissionTap: handlePermissionRequest)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: messages.count) { _, _ in
                        // Auto-scroll to latest message
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // User input (only show when awaiting input)
                if awaitingUserInput {
                    HStack(spacing: 12) {
                        TextField("Type here...", text: $userInput)
                            .textFieldStyle(.plain)
                            .foregroundColor(Color(red: 0.15, green: 0.20, blue: 0.35))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.85))
                            )

                        Button(action: sendUserMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.15, green: 0.20, blue: 0.35))
                        }
                        .disabled(userInput.isEmpty)
                        .opacity(userInput.isEmpty ? 0.4 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            startConversation()
        }
    }

    // MARK: - Conversation Logic

    private func startConversation() {
        isOrbGlowing = true

        // Session 1: Core onboarding
        if currentSession == 1 && userName.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                addMessage(.contextual("Hello. I'm Contextual."))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                addMessage(.contextual("Give me 2 minutes, and I'll start showing you everything you don't even know that you love yet."))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                addMessage(.contextual("What's your name?"))
                awaitingUserInput = true
            }
        } else if currentSession == 1 && !userName.isEmpty {
            // Resume Session 1
            continueSessionOne()
        }
    }

    private func sendUserMessage() {
        guard !userInput.isEmpty else { return }

        let message = userInput
        userInput = ""
        awaitingUserInput = false

        addMessage(.user(message))

        // Process response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handleUserResponse(message)
        }
    }

    private func handleUserResponse(_ response: String) {
        conversationStep += 1

        switch conversationStep {
        case 1: // User gave name
            userName = response
            addMessage(.contextual("Hi \(userName.split(separator: " ").first ?? ""). Let's get you set up for the basics."))

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                continueSessionOne()
            }

        default:
            break
        }
    }

    private func continueSessionOne() {
        // Location permission
        if perms.locationAuth != .authorizedAlways && perms.locationAuth != .authorizedWhenInUse {
            addMessage(.contextual("Contextual uses your real life and location as the center of all things."))

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                addMessage(.contextual("In order to use Contextual, we need permission to know your location."))
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                addMessage(.permissionRequest(.location))
            }
        } else {
            requestAudioSetup()
        }
    }

    private func requestAudioSetup() {
        addMessage(.contextual("Great. Next up is getting this screen out of your face."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            addMessage(.contextual("Contextual is meant to put your IRL life first and get you off your phone."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            addMessage(.contextual("We use your AirPods to 'whisper' to you quietly when there's something nearby."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            addMessage(.contextual("Do you have AirPods nearby? Put them in if you do."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            addMessage(.contextual("Can I send you a test whisper?"))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 11.5) {
            addMessage(.permissionRequest(.audio))
        }
    }

    private func requestMediaPermission() {
        addMessage(.contextual("One more thing."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            addMessage(.contextual("If I can see your photos and their locations, I can surprise you with memories when you're nearby."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            addMessage(.permissionRequest(.photos))
        }
    }

    private func requestAIConsent() {
        addMessage(.contextual("Before we go further..."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            addMessage(.contextual("I use AI to understand you better and give you smarter whispers."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            addMessage(.contextual("I'll also remember our conversations over time. Is that okay?"))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            addMessage(.permissionRequest(.calendar))  // Using calendar as AI consent placeholder
        }
    }

    private func requestMotionPermission() {
        addMessage(.contextual("One more quick thing."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            addMessage(.contextual("If I can sense when you're walking, driving, or stationary, I'll know better when to whisper."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            addMessage(.permissionRequest(.tasks))  // Using tasks as motion permission
        }
    }

    private func completeSessionOne() {
        addMessage(.contextual("Perfect."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            addMessage(.contextual("Get that screen out of your face, put your AirPods in, and I'll take it from there."))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            hasCompletedOnboarding = true
            dismiss()
        }
    }

    private func handlePermissionRequest(_ type: OnboardingMessage.PermissionType) {
        switch type {
        case .location:
            perms.requestLocationAlways()
            // Wait for permission to be granted
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if perms.locationAuth == .authorizedAlways || perms.locationAuth == .authorizedWhenInUse {
                    requestAudioSetup()
                }
            }

        case .audio:
            // Play test whisper
            playTestWhisper()
            // Then continue to AI consent
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                requestAIConsent()
            }

        case .calendar:
            // This represents AI consent (no actual iOS permission)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                requestMotionPermission()
            }

        case .tasks:
            // Motion permission
            perms.requestMotion()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                requestMediaPermission()
            }

        case .photos:
            // Request photos permission
            requestPhotosAccess()

        case .contacts:
            // Unused for now
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completeSessionOne()
            }

        default:
            break
        }
    }

    private func playTestWhisper() {
        addMessage(.contextual("Perfect. Here's what a whisper sounds like..."))

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Play actual whisper via WhisperEngine
            let firstName = String(userName.split(separator: " ").first ?? "")
            let testMessage = "Hello \(firstName). This is what I sound like when I whisper."
            whisperEngine.speak(text: testMessage, category: "onboarding")
        }
    }

    private func requestPhotosAccess() {
        // Request iOS photos permission
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                // Complete onboarding
                completeSessionOne()
            }
        }
    }

    private func addMessage(_ message: OnboardingMessage) {
        withAnimation(.easeOut(duration: 0.3)) {
            messages.append(message)
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: OnboardingMessage
    let onPermissionTap: (OnboardingMessage.PermissionType) -> Void

    var body: some View {
        HStack {
            if case .user = message {
                Spacer()
            }

            Group {
                switch message {
                case .contextual(let text):
                    Text(text)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.20, blue: 0.35))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.85))
                        )
                        .frame(maxWidth: 280, alignment: .leading)

                case .user(let text):
                    Text(text)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.15, green: 0.20, blue: 0.35))
                        )
                        .frame(maxWidth: 280, alignment: .trailing)

                case .permissionRequest(let type):
                    Button(action: { onPermissionTap(type) }) {
                        HStack {
                            Image(systemName: permissionIcon(type))
                                .font(.system(size: 18))
                            Text(permissionText(type))
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: 0.15, green: 0.20, blue: 0.35))
                        )
                    }

                case .typing:
                    HStack(spacing: 6) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.6))
                    )
                }
            }

            if case .contextual = message {
                Spacer()
            }
        }
    }

    private func permissionIcon(_ type: OnboardingMessage.PermissionType) -> String {
        switch type {
        case .location: return "location.fill"
        case .audio: return "airpodspro"
        case .calendar: return "calendar"
        case .tasks: return "checkmark.circle"
        case .contacts: return "person.2.fill"
        case .photos: return "photo.fill"
        }
    }

    private func permissionText(_ type: OnboardingMessage.PermissionType) -> String {
        switch type {
        case .location: return "Grant Location"
        case .audio: return "Yes, test it"
        case .calendar: return "Yes, that's okay"
        case .tasks: return "Grant Motion"
        case .contacts: return "Grant Contacts"
        case .photos: return "Grant Photos"
        }
    }
}

#Preview {
    ConversationalOnboardingView()
        .environmentObject(PermissionsManager.shared)
}
