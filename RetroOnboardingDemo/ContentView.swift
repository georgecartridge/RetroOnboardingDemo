//
//  ContentView.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
                        try await Task.sleep(nanoseconds: 500_000_000)
                        print(answer)
                    }
                ),
                FormStep(
                    label: "Enter your verification code...",
                    keyboardType: .numberPad,
                    onSubmit: { answer in
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        print(answer)
                    }
                ),
                FormStep(
                    label: "Enter your username...",
                    keyboardType: .default,
                    onSubmit: { answer in
                        print(answer)
                    }
                )
            ],
            onComplete: {
                print("The form has been completed")
            }
        )
    }
}

#Preview {
    ContentView()
}
