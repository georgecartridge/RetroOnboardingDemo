//
//  InputField.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

enum FieldState {
    case idle
    case loading
    case success
    case error
}

struct InputField: View {
    let label: String
    @Binding var value: String
    let keyboardType: UIKeyboardType
    @Binding var state: FieldState
    let onReturn: () -> Void
    
    var body: some View {
        HStack {
            Group {
                if state == .idle {
                    Image(systemName: "chevron.forward")
                        .symbolEffect(.pulse, options: .speed(2))
                } else if state == .loading {
                    ProgressView()
                } else if state == .success {
                    Image(systemName: "checkmark")
                } else if state == .error {
                    Image(systemName: "xmark")
                }
            }
            .font(.system(size: 24))
            .frame(width: 24, height: 24)
            
            TextField(label, text: $value, prompt: Text(label).foregroundStyle(.black))
                .keyboardType(keyboardType)
                .onSubmit(onReturn)
        }
        .opacity(state == .success ? 0.5 : 1)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var value = ""
    @Previewable @State var state: FieldState = .idle
    
    InputField(
        label: "Enter your phone number...",
        value: $value,
        keyboardType: .phonePad,
        state: $state,
        onReturn: {}
    )
}
