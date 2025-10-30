//
//  OnboardingFlow.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

struct OnboardingFlow: View {
    let title: String
    let logoItems: [LogoBounceItem]
    let form: [FormStep]
    var onComplete: (() -> Void)?
    
    @State private var selected = 0
    @State private var isPresented = false
    @State private var logoStartPosition: CGPoint = .zero
    
    @Namespace private var namespace
    
    var body: some View {
        if !isPresented {
            WelcomeScreen(
                title: title,
                selected: $selected,
                isPresented: $isPresented,
                namespace: namespace,
                logoBounceItems: logoItems,
                startPosition: $logoStartPosition
            )
        } else {
            OnboardingFormScreen(
                form: form,
                onComplete: onComplete,
                isPresented: $isPresented,
                image: logoItems[selected].image,
                namespace: namespace,
            )
            .transition(.asymmetric(insertion: .push(from: .bottom).combined(with: .scale(scale: 0.3)), removal: .scale(scale: 1).combined(with: .move(edge: .bottom)).combined(with: .opacity)))
        }
    }
}

#Preview {
    OnboardingFlow(
        title: "Demo",
        logoItems: [
            LogoBounceItem(image: "torus-1", text: "Recap Your Life"),
            LogoBounceItem(image: "torus-2", text: "Week to Week"),
            LogoBounceItem(image: "torus-3", text: "Friends Only"),
            LogoBounceItem(image: "torus-4", text: "Feel Good Social")
        ],
        form: [
            FormStep(
                label: "Enter your phone number...",
                keyboardType: .phonePad,
                onSubmit: { answer in
                    print("Phone number entered = \(answer)")
                }
            ),
            FormStep(
                label: "Enter your verification code...",
                keyboardType: .numberPad,
                onSubmit: { answer in
                    print("Verification code entered = \(answer)")
                }
            ),
            FormStep(
                label: "Enter your username...",
                keyboardType: .default,
                onSubmit: { answer in
                    print("Username entered = \(answer)")
                }
            )
        ],
        onComplete: {
            print("The form has been completed")
        }
    )
}
