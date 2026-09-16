import SwiftUI
import Combine

@MainActor
final class MusicPlayerModel: ObservableObject {
    @Published var songTitle = "Blinding Lights"
    @Published var artistName = "The Weeknd"
    @Published var isSimulatingPlaying = false
    @Published var progress = 0.35

    private var timer: Timer?

    func togglePlayPause() {
        isSimulatingPlaying.toggle()
        isSimulatingPlaying ? startTimer() : stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.isSimulatingPlaying else { return }
                self.progress += 0.005
                if self.progress >= 1 { self.progress = 0 }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit { timer?.invalidate() }
}
