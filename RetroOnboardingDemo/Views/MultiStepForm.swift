//
//  MultiStepForm.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

public struct FormStep: Identifiable {
    public let id = UUID()
    let label: String
    var value: String = ""
    let keyboardType: UIKeyboardType
    let onSubmit: (String) async throws -> Void
    var state: FieldState = .idle
}

struct MultiStepForm: View {
    @State var steps: [FormStep]
    @State var currentStep = 0
    @FocusState.Binding var focusedStep: UUID?
    
    var onComplete: (() -> Void)?
    
    private var reversedSteps: [(offset: Int, element: Binding<FormStep>)] {
        Array($steps.enumerated()).reversed()
    }
    
    var body: some View {
        VStack {
            ForEach(reversedSteps, id: \.offset) { index, $step in
                if currentStep >= index {
                    InputField(
                        label: step.label,
                        value: $step.value,
                        keyboardType: step.keyboardType,
                        state: $step.state,
                        onReturn: submitCurrentStep,
                    )
                    .focused($focusedStep, equals: step.id)
                    .disabled(index < currentStep)
                    .padding([.vertical], 12)
                }
            }
            
            Spacer()
            
            if currentStep < steps.count && steps[steps.count - 1].state != .success {
                Button("Next") {
                    submitCurrentStep()
                }
                .font(.largeTitle.bold())
                .foregroundStyle(steps[currentStep].value.isEmpty ? .black.opacity(0.3) : .black)
                .disabled(steps[currentStep].value.isEmpty)
            }
        }
        .onAppear {
            guard steps.count > 0 else { return }
            
            focusedStep = steps[0].id
        }
        .onChange(of: currentStep) { _, nextStep in
            guard nextStep < steps.count else {
                focusedStep = nil
                return
            }
            
            focusedStep = steps[nextStep].id
        }
    }
    
    private func submitCurrentStep() {
        guard currentStep >= 0 && currentStep < steps.count else { return }
        
        let submitAction = steps[currentStep].onSubmit
        let answer = steps[currentStep].value
        
        steps[currentStep].state = .loading
        
        Task {
            do {
                try await submitAction(answer)
                
                steps[currentStep].state = .success
                
                if currentStep == steps.count - 1 {
                    onComplete?()
                }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = currentStep + 1
                }
            } catch {
                steps[currentStep].state = .error
            }
        }
    }
}

#Preview {
    @FocusState var focusedStep: UUID?
    
    let steps = [
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
                try await Task.sleep(nanoseconds: 2_000_000_000)
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
    ]
    
    MultiStepForm(
        steps: steps,
        focusedStep: $focusedStep,
        onComplete: {
            print("Completed!!!")
        }
    )
}
