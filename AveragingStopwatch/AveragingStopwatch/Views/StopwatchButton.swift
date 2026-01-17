import SwiftUI

struct StopwatchButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    var isDisabled: Bool = false

    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        if isDisabled {
            return Theme.neutralGray.opacity(0.05)
        }
        return color.opacity(0.15)
    }

    private var foregroundColor: Color {
        if isDisabled {
            return Theme.neutralGray.opacity(0.4)
        }
        return color
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(Theme.Typography.buttonLabel)
                .frame(width: Theme.buttonSize, height: Theme.buttonSize)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(Circle())
                .shadow(
                    color: colorScheme == .light ? Color.black.opacity(0.06) : Color.clear,
                    radius: 4,
                    x: 0,
                    y: 2
                )
        }
        .disabled(isDisabled)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(isPressed ? Theme.Animation.buttonPress : Theme.Animation.buttonRelease, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isDisabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .accessibilityLabel(title)
    }
}

// MARK: - Button Style Variants

extension StopwatchButton {
    static func start(action: @escaping () -> Void) -> StopwatchButton {
        StopwatchButton(title: "Start", color: Theme.activeGreen, action: action)
    }

    static func stop(action: @escaping () -> Void) -> StopwatchButton {
        StopwatchButton(title: "Stop", color: Theme.stopRed, action: action)
    }

    static func lap(action: @escaping () -> Void, isDisabled: Bool = false) -> StopwatchButton {
        StopwatchButton(title: "Lap", color: Theme.neutralGray, action: action, isDisabled: isDisabled)
    }

    static func reset(action: @escaping () -> Void) -> StopwatchButton {
        StopwatchButton(title: "Reset", color: Theme.neutralGray, action: action)
    }

    static func done(action: @escaping () -> Void, isDisabled: Bool = false) -> StopwatchButton {
        StopwatchButton(title: "Done", color: Theme.actionBlue, action: action, isDisabled: isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            StopwatchButton.lap(action: {})
            StopwatchButton.start(action: {})
            StopwatchButton.done(action: {})
        }
        HStack(spacing: 20) {
            StopwatchButton.reset(action: {})
            StopwatchButton.stop(action: {})
            StopwatchButton.done(action: {}, isDisabled: true)
        }
    }
    .padding()
}
