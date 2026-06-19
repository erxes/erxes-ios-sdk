import Foundation
import Speech
import AVFoundation
import SwiftUI

/// Live speech-to-text using the on-device Speech framework. Captures mic audio
/// through `AVAudioEngine`, streams it to `SFSpeechRecognizer`, and publishes the
/// running `transcript`. All published mutations happen on the main thread.
final class SpeechTranscriber: ObservableObject {
    @Published private(set) var isRecording = false
    @Published private(set) var transcript = ""
    /// Set when speech or microphone permission is denied / recognition unavailable.
    @Published private(set) var unavailable = false
    @Published private(set) var errorMessage: String?

    private let recognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var isStarting = false
    private var hasInputTap = false

    /// Requests permissions (speech + mic), then starts live transcription.
    func start() {
        guard !isStarting && !isRecording else { return }
        isStarting = true
        unavailable = false
        errorMessage = nil
        transcript = ""
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard let self else { return }
                guard status == .authorized else {
                    self.isStarting = false
                    self.unavailable = true
                    self.errorMessage = self.authorizationMessage(for: status)
                    return
                }
                self.requestMic()
            }
        }
    }

    private func requestMic() {
        let handler: (Bool) -> Void = { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard granted else {
                    self.isStarting = false
                    self.unavailable = true
                    self.errorMessage = "Microphone permission is disabled"
                    return
                }
                self.begin()
            }
        }
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission(completionHandler: handler)
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission(handler)
        }
    }

    private func begin() {
        guard let recognizer, recognizer.isAvailable else {
            isStarting = false
            unavailable = true
            errorMessage = "Speech recognition is unavailable"
            return
        }
        do {
            removeInputTapIfNeeded()
            task?.cancel()
            task = nil

            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            let req = SFSpeechAudioBufferRecognitionRequest()
            req.shouldReportPartialResults = true
            req.taskHint = .dictation
            request = req

            let input = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)
            guard format.sampleRate > 0, format.channelCount > 0 else {
                throw SpeechTranscriberError.invalidInputFormat
            }
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.request?.append(buffer)
            }
            hasInputTap = true
            audioEngine.prepare()
            try audioEngine.start()
            isStarting = false
            isRecording = true

            task = recognizer.recognitionTask(with: req) { [weak self] result, error in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if let result {
                        self.transcript = result.bestTranscription.formattedString
                    }
                    if let error {
                        let nsError = error as NSError
                        SDKLogger.error("Speech recognition failed: \(nsError.domain) \(nsError.code) \(nsError.localizedDescription)")
                        self.errorMessage = self.recognitionMessage(for: nsError)
                        self.teardownEngine()
                    } else if result?.isFinal ?? false {
                        self.teardownEngine()
                    }
                }
            }
        } catch {
            SDKLogger.error("Speech start failed: \(error.localizedDescription)")
            errorMessage = startMessage(for: error)
            isStarting = false
            teardownEngine()
        }
    }

    /// Stops capturing audio; the recognizer emits a final transcript shortly after.
    func stop() {
        request?.endAudio()
        teardownEngine()
    }

    /// Stops and discards (used when the view disappears mid-dictation).
    func cancel() {
        task?.cancel()
        task = nil
        teardownEngine()
    }

    private func teardownEngine() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        removeInputTapIfNeeded()
        request = nil
        isStarting = false
        isRecording = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func removeInputTapIfNeeded() {
        guard hasInputTap else { return }
        audioEngine.inputNode.removeTap(onBus: 0)
        hasInputTap = false
    }

    private func authorizationMessage(for status: SFSpeechRecognizerAuthorizationStatus) -> String {
        switch status {
        case .denied:
            return "Speech recognition permission is disabled"
        case .restricted:
            return "Speech recognition is restricted on this device"
        case .notDetermined:
            return "Speech recognition permission was not granted"
        case .authorized:
            return ""
        @unknown default:
            return "Speech recognition permission failed"
        }
    }

    private func startMessage(for error: Error) -> String {
        if error is SpeechTranscriberError {
            return "Microphone input is unavailable"
        }
        return "Could not start microphone"
    }

    private func recognitionMessage(for error: NSError) -> String {
        if error.domain == "kAFAssistantErrorDomain", error.code == 1110 {
            return "No speech was detected"
        }
        return "Speech recognition stopped"
    }

    deinit {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        removeInputTapIfNeeded()
        task?.cancel()
    }
}

private enum SpeechTranscriberError: LocalizedError {
    case invalidInputFormat

    var errorDescription: String? {
        "Microphone input format is invalid"
    }
}

/// Animated bars shown while dictation is active ("audio flow").
struct RecordingWaveformView: View {
    var color: Color = .secondary
    private let heights: [CGFloat] = [10, 22, 14, 24, 12]
    @State private var animating = false

    var body: some View {
        HStack(spacing: 3) {
            ForEach(heights.indices, id: \.self) { i in
                Capsule()
                    .fill(color)
                    .frame(width: 3, height: animating ? heights[i] : 6)
                    .animation(
                        .easeInOut(duration: 0.45)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.08),
                        value: animating
                    )
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear { animating = true }
    }
}
