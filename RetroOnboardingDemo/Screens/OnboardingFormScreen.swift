//
//  OnboardingFormScreen.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

struct OnboardingFormScreen: View {
    let form: [FormStep]
    var onComplete: (() -> Void)?
    
    @Binding var isPresented: Bool
    let image: String
    let namespace: Namespace.ID
    
    @FocusState private var focusedStep: UUID?
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .matchedGeometryEffect(id: "icon", in: namespace)
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
                .frame(width: 80)
                .onTapGesture {
                    focusedStep = nil
                    
                    withAnimation(.spring(duration: 0.4)) {
                        isPresented.toggle()
                    }
                }
            
            Group {
                MultiStepForm(
                    steps: form,
                    focusedStep: $focusedStep,
                    onComplete: onComplete
                )
                .padding(.top, 10)
            }
            .transition(.move(edge: .bottom))
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var isPresented = false
    @Previewable @Namespace var namespace
    
    OnboardingFormScreen(
        form: [
            FormStep(
                label: "Enter your phone number...",
                keyboardType: .phonePad,
                onSubmit: { answer in
                    print(answer)
                }
            ),
            FormStep(
                label: "Enter your verification code...",
                keyboardType: .numberPad,
                onSubmit: { answer in
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
        isPresented: $isPresented,
        image: "torus-1",
        namespace: namespace
    )
}
