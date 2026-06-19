import SwiftUI
import AVFoundation

/// Streams and plays a remote audio attachment. Published state is updated from
/// AVPlayer callbacks scheduled on the main queue, so no `@MainActor` is needed.
final class AudioPlaybackController: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0      // 0...1
    @Published var elapsed: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var endObserver: NSObjectProtocol?

    func toggle(url: URL?) {
        guard let url else { return }
        if player == nil { prepare(url: url) }

        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            try? AVAudioSession.sharedInstance().setActive(true)
            player?.play()
            isPlaying = true
        }
    }

    private func prepare(url: URL) {
        let item = AVPlayerItem(url: url)
        let p = AVPlayer(playerItem: item)
        player = p

        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        timeObserver = p.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            let current = time.seconds
            let total = item.duration.seconds
            self.elapsed = current.isFinite ? current : 0
            if total.isFinite, total > 0 {
                self.duration = total
                self.progress = min(1, max(0, current / total))
            }
        }

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.isPlaying = false
            self.progress = 0
            self.elapsed = 0
            self.player?.seek(to: .zero)
        }
    }

    deinit {
        if let timeObserver { player?.removeTimeObserver(timeObserver) }
        if let endObserver { NotificationCenter.default.removeObserver(endObserver) }
    }
}

/// A voice-message bubble: play/pause button, progress bar, and a time label.
struct AudioMessageView: View {
    let url: URL?
    var isFromCustomer: Bool = false

    @StateObject private var controller = AudioPlaybackController()

    private var tint: Color { isFromCustomer ? .white : .primary }

    var body: some View {
        HStack(spacing: 12) {
            Button { controller.toggle(url: url) } label: {
                Image(systemName: controller.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(isFromCustomer ? Color.accentColor : Color.white)
                    .frame(width: 34, height: 34)
                    .background(isFromCustomer ? Color.white : Color.accentColor, in: Circle())
            }
            .buttonStyle(.plain)

            ProgressView(value: controller.progress)
                .progressViewStyle(.linear)
                .tint(tint)
                .frame(width: 120)

            Text(timeLabel)
                .font(.caption.monospacedDigit())
                .foregroundStyle(tint.opacity(0.85))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            isFromCustomer ? AnyShapeStyle(Color.white.opacity(0.2))
                           : AnyShapeStyle(Color.gray.opacity(0.15)),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
    }

    private var timeLabel: String {
        let shown = controller.isPlaying || controller.elapsed > 0
            ? controller.elapsed : controller.duration
        let secs = Int(shown.rounded())
        return String(format: "%d:%02d", secs / 60, secs % 60)
    }
}
