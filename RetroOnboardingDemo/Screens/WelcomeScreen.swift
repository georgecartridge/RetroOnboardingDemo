//
//  WelcomeScreen.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI
import SpriteKit

struct LogoBounceItem {
    let image: String
    let text: String
}

struct WelcomeScreen: View {
    let title: String
    
    @Binding var selected: Int
    @Binding var isPresented: Bool
    var namespace: Namespace.ID
    var logoBounceItems: [LogoBounceItem]
    @Binding var startPosition: CGPoint
    
    var body: some View {
        ZStack {
            LogoBounceAnimation(
                startPosition: startPosition,
                selected: $selected,
                logoBounceItems: logoBounceItems,
                namespace: namespace,
                isPaused: isPresented
            )
            
            VStack {
                Spacer()
                
                Text("Demo")
                    .font(.custom("PlayfairDisplay-Regular", size: 64).weight(.heavy))
                
                Text(logoBounceItems[selected].text)
                    .font(.largeTitle)
                    .opacity(0.4)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(duration: 0.3)) {
                        isPresented.toggle()
                    }
                }) {
                    Text("Let's go")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .background(.black)
                        .cornerRadius(.infinity)
                }
                .padding()
            }
        }
        .onAppear {
            if startPosition == .zero {
                startPosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - 180)
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented = false
    @Previewable @State var selected = 0
    @Previewable @State var startPosition: CGPoint = .zero
    
    @Previewable @Namespace var namespace
    
    var logoBounceItems: [LogoBounceItem] = [
        LogoBounceItem(image: "torus-1", text: "Recap Your Life"),
        LogoBounceItem(image: "torus-2", text: "Week to Week"),
        LogoBounceItem(image: "torus-3", text: "Friends Only"),
        LogoBounceItem(image: "torus-4", text: "Feel Good Social")
    ]
    
    WelcomeScreen(
        title: "Demo",
        selected: $selected,
        isPresented: $isPresented,
        namespace: namespace,
        logoBounceItems: logoBounceItems,
        startPosition: $startPosition
    )
}
