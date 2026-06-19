import SwiftUI

/// The shared message-composer pill used by both the in-conversation chat
/// (`ChatContentView`) and the new-chat home (`MessengerChatModeView`).
///
/// Layout (empty): [+] · text field · mic
/// Layout (text):  [+] · text field · ⬆︎ send
/// Layout (dictating): [⏹ stop] · live transcript · animated waveform
///
/// Owns the live speech-to-text dictation; the transcript streams into the bound
/// `text` (preserving anything already typed). Sending is delegated to `onSend`.
struct MessageComposerBar: View {
    @Binding var text: String
    var placeholder: String = "Message…"
    var primary: Color
    /// Extra reason the send button should be enabled (e.g. pending attachments).
    var hasAttachments: Bool = false
    /// Focus owned by the parent so it can react (e.g. scroll on keyboard show).
    var focused: FocusState<Bool>.Binding
    /// Whether to show the leading "+" attachment button.
    var showsAttachment: Bool = true
    var onPlus: () -> Void = {}
    var onSend: () -> Void

    @StateObject private var transcriber = SpeechTranscriber()
    /// Text already present when dictation began; the transcript is appended to it.
    @State private var dictationBase = ""

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || hasAttachments
    }

    private var fieldPlaceholder: String {
        if transcriber.isRecording { return "Listening…" }
        return transcriber.errorMessage ?? placeholder
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            leading
            field
            trailing
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .liquidGlass(
            shape: RoundedRectangle(cornerRadius: 28, style: .continuous),
            shadowRadius: 8
        )
        .animation(.easeInOut(duration: 0.2), value: transcriber.isRecording)
        // Live dictation streams into the field (preserving any pre-typed text).
        .onChange(of: transcriber.transcript) { newValue in
            text = dictationBase + newValue
        }
        .onDisappear { transcriber.cancel() }
    }

    // MARK: - Leading ("+" / stop)

    @ViewBuilder
    private var leading: some View {
        if transcriber.isRecording {
            Button { transcriber.stop() } label: {
                Image(systemName: "stop.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Color.red, in: Circle())
            }
            .accessibilityLabel("Stop dictation")
        } else if showsAttachment {
            Button(action: onPlus) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 34, height: 34)
                    .background(Color.primary.opacity(0.08), in: Circle())
            }
        }
    }

    // MARK: - Text field

    private var field: some View {
        TextField(fieldPlaceholder, text: $text, axis: .vertical)
            .lineLimit(1...5)
            .focused(focused)
            // Live transcript drives the field while dictating.
            .disabled(transcriber.isRecording)
            .frame(minHeight: 34, alignment: .center)
    }

    // MARK: - Trailing (send / mic / audio flow)

    @ViewBuilder
    private var trailing: some View {
        if transcriber.isRecording {
            // "Audio flow" — animated waveform while dictation is active.
            RecordingWaveformView(color: primary)
                .frame(width: 40, height: 34)
        } else if canSend {
            Button(action: onSend) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(primary, in: Circle())
            }
        } else {
            Button { startDictation() } label: {
                Image(systemName: "mic")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(primary, in: Circle())
            }
            .accessibilityLabel("Dictate")
        }
    }

    private func startDictation() {
        focused.wrappedValue = false
        let existing = text.trimmingCharacters(in: .whitespacesAndNewlines)
        dictationBase = existing.isEmpty ? "" : existing + " "
        transcriber.start()
    }
}
