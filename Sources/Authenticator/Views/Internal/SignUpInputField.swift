//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct SignUpInputField: View {
    @Environment(\.authenticatorOptions) private var options
    @Environment(\.authenticatorTheme) var theme
    @ObservedObject private var field: SignUpState.Field
    @ObservedObject private var validator: Validator

    init(
        field: SignUpState.Field,
        validator: Validator
    ) {
        self.field = field
        self.validator = validator
    }

    var body: some View {
        Group {
            if let customField = field.field as? CustomSignUpField {
                customView(for: customField)
            } else if let baseField = field.field as? BaseSignUpField {
                regularView(for: baseField)
            }
        }
    }

    @ViewBuilder func regularView(for field: BaseSignUpField) -> some View {
        Group {
            switch field.inputType {
            case .text:
                TextField(
                    field.displayedLabel,
                    text: $field.value,
                    placeholder: field.placeholder,
                    validator: validator
                )
            case .password:
                PasswordField(
                    field.displayedLabel,
                    text: $field.value,
                    placeholder: field.placeholder,
                    validator: validator
                )
#if os(iOS)
                .textContentType(.newPassword)
                .textInputAutocapitalization(.never)
#elseif os(macOS)
                .textContentType(.password)
#endif
            case .date:
                DatePicker(
                    field.displayedLabel,
                    text: $field.value,
                    placeholder: field.placeholder,
                    validator: validator
                )
            case .phoneNumber:
                PhoneNumberField(
                    field.displayedLabel,
                    text: $field.value,
                    placeholder: field.placeholder,
                    validator: validator
                )
            }
        }
        .textContentType(field.attributeType.textContentType)
    #if os(iOS)
        .keyboardType(field.attributeType.keyboardType)
    #endif
    }

    @ViewBuilder func customView(for field: CustomSignUpField) -> some View {
        VStack(alignment: .leading, spacing: theme.components.field.spacing.vertical) {
            if let label = field.displayedLabel {
                HStack {
                    SwiftUI.Text(label)
                        .foregroundColor(foregroundColor)
                        .font(theme.fonts.body)
                        .accessibilityHidden(true)
                    Spacer()
                }
            }
            AnyView(
                field.content($field.value)
            )
            .onChange(of: self.field.value) { _ in
                validator.validate()
            }
            .onAppear {
                validator.value = $field.value
            }
            if case .error(let message) = validator.state, let errorMessage = message {
                AnyView(
                    field.errorContent(String(format: errorMessage, field.label ?? "authenticator.validator.field".localized()))
                        .font(theme.fonts.subheadline)
                )
                .foregroundColor(foregroundColor)
                .transition(options.contentTransition)
                .accessibilityHidden(true)
            }
        }
    }
    
    private var foregroundColor: Color {
        switch validator.state {
        case .normal:
            return theme.colors.foreground.secondary
        case .error:
            return theme.colors.foreground.error
        }
    }
}
