//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// This Button follows Amplify UI theming.
struct Button: View {
    @Environment(\.authenticatorTheme) var theme
    private var viewModifiers = ViewModifiers()
    let action: () -> Void
    let label: String

    init(
        _ label: String,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.action = action
    }

    var body: some View {
        SwiftUI.Button(label, action: action)
            .buttonStyle(buttonStyle)
    }

    private var backgroundColor: Color {
        switch viewModifiers.style {
        case .primary:
            return theme.Colors.Background.interactive
        case .link:
            return .clear
        default:
            return theme.Colors.Background.error
        }
    }

    private var foregroundColor: Color {
        switch viewModifiers.style {
        case .primary:
            return theme.Colors.Foreground.inverse
        case .link:
            return theme.Colors.Foreground.interactive
        default:
            return theme.Colors.Foreground.primary
        }
    }

    private var cornerRadius: CGFloat {
        switch viewModifiers.style {
        case .primary:
            return theme.Buttons.primary.cornerRadius
        case .link:
            return theme.Buttons.link.cornerRadius
        default:
            return theme.Authenticator.style.cornerRadius
        }
    }

    private var borderColor: Color {
        switch viewModifiers.style {
        case .default:
            return theme.Colors.Border.interactive
        default:
            return .clear
        }
    }

    private var borderWidth: CGFloat {
        switch viewModifiers.style {
        case .default:
            return theme.Authenticator.style.borderWidth
        default:
            return 0
        }
    }

    private var font: Font {
        switch viewModifiers.style {
        case .primary:
            return theme.Buttons.primary.font
        case .link:
            return theme.Buttons.link.font
        default:
            return theme.Fonts.body
        }
    }

    private var padding: CGFloat? {
        switch viewModifiers.style {
        case .primary:
            return theme.Buttons.primary.padding
        case .link:
            return theme.Buttons.link.padding
        default:
            return theme.Authenticator.style.padding
        }
    }

    private var buttonStyle: some ButtonStyle {
        return AuthenticatorButtonStyle(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            padding: padding,
            maxWidth: viewModifiers.frame.maxWidth
        )
    }
}

extension Button {
    private struct ViewModifiers {
        var frame = Frame()
        var style: Style = .default

        struct Border {
            var color: Color = .primary
            var width: CGFloat = 1
        }

        struct Frame {
            var minWidth: CGFloat? = nil
            var idealWidth: CGFloat? = nil
            var maxWidth: CGFloat? = .infinity
            var minHeight: CGFloat? = nil
            var idealHeight: CGFloat? = nil
            var maxHeight: CGFloat? = nil
            var alignment: Alignment = .center
        }
    }

    enum Style {
        case `default`
        case primary
        case link
    }

    func frame(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> Button {
        var view = self
        view.viewModifiers.frame.minWidth = minWidth
        view.viewModifiers.frame.idealWidth = idealWidth
        view.viewModifiers.frame.maxWidth = maxWidth
        view.viewModifiers.frame.minHeight = minHeight
        view.viewModifiers.frame.idealHeight = idealHeight
        view.viewModifiers.frame.maxHeight = maxHeight
        view.viewModifiers.frame.alignment = alignment
        return view
    }

    func buttonStyle(_ buttonStyle: Button.Style) -> Button {
        var view = self
        view.viewModifiers.style = buttonStyle
        return view
    }
}

private struct AuthenticatorButtonStyle: ButtonStyle {
    let font: Font
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let padding: CGFloat?
    let maxWidth: CGFloat?

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(font)
            .padding(.all, padding)
            .multilineTextAlignment(.center)
            .frame(maxWidth: maxWidth)
            .foregroundColor(configuration.isPressed ? foregroundColor.opacity(0.5) : foregroundColor)
            .background(configuration.isPressed ? backgroundColor.opacity(0.5) : backgroundColor)
            .cornerRadius(cornerRadius)
    }
}