import SwiftUI
import Combine

enum IslandMode: Equatable {
    case reduced
    case expanded
    case music
    case call
    case notification
}

@MainActor
final class IslandModel: ObservableObject {
    @Published var mode: IslandMode = .reduced
    @Published var musicPlayer = MusicPlayerModel()

    @Published var songTitle: String = "Blinding Lights"
    @Published var artistName: String = "The Weeknd"
    @Published var callContact: String = "Ana"
    @Published var callDuration: String = "00:42"
    @Published var notificationApp: String = "Mensajes"
    @Published var notificationText: String = "Hola, te escribí hace un rato."

    private var callTimer: Timer?
    private var callSeconds: Int = 42

    init() {
        songTitle = musicPlayer.songTitle
        artistName = musicPlayer.artistName
    }

    func handleTap() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            switch mode {
            case .reduced: mode = .expanded
            case .expanded: mode = .reduced
            case .music: musicPlayer.togglePlayPause()
            case .call: endCall()
            case .notification: closeNotification()
            }
        }
    }

    func handleLongPress() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
            switch mode {
            case .reduced:
                mode = .music
                if !musicPlayer.isSimulatingPlaying { musicPlayer.togglePlayPause() }
            case .music:
                if musicPlayer.isSimulatingPlaying { musicPlayer.togglePlayPause() }
                mode = .reduced
            case .call: endCall()
            case .notification: closeNotification()
            case .expanded: mode = .reduced
            }
        }
    }

    func startCallSimulation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            mode = .call
            callSeconds = 42
            callDuration = "00:42"
            startCallTimer()
        }
    }

    func endCall() {
        callTimer?.invalidate()
        callTimer = nil
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { mode = .reduced }
    }

    private func startCallTimer() {
        callTimer?.invalidate()
        callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, self.mode == .call else { return }
                self.callSeconds += 1
                self.callDuration = String(format: "%02d:%02d", self.callSeconds / 60, self.callSeconds % 60)
            }
        }
    }

    func triggerNotificationSimulation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { mode = .notification }
    }

    func replyToNotification() {
        notificationText = "Respuesta de prueba enviada ✓"
    }

    func closeNotification() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { mode = .reduced }
    }

    deinit { callTimer?.invalidate() }
}
