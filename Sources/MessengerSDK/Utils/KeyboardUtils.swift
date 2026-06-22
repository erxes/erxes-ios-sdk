import SwiftUI
import UIKit

// MARK: - Global keyboard dismiss

func dismissKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil, from: nil, for: nil
    )
}

// MARK: - Tap-anywhere-to-dismiss modifier

/// Dismisses the keyboard when the user taps anywhere in the modified view.
///
/// Uses `simultaneousGesture` so the tap fires alongside SwiftUI's built-in
/// gestures (ScrollView pan, Button tap, etc.) without consuming or blocking
/// them. The previous UIViewRepresentable background approach didn't work
/// because the ScrollView's hit-test layer sits in front of any background
/// view and intercepts all touches before they reach it.
struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded { dismissKeyboard() }
            )
    }
}

struct DismissKeyboardOnVerticalDrag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in
                        let horizontal = abs(value.translation.width)
                        let vertical = abs(value.translation.height)
                        guard vertical > horizontal else { return }
                        dismissKeyboard()
                    }
            )
    }
}

extension View {
    /// Dismisses the keyboard when the user taps anywhere in this view.
    /// Buttons, scroll gestures, and other interactions still work normally.
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }

    /// Dismisses the keyboard as soon as the user starts a vertical drag.
    func dismissKeyboardOnVerticalDrag() -> some View {
        modifier(DismissKeyboardOnVerticalDrag())
    }
}
