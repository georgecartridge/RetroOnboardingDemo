//
//  LogoBounceAnimation.swift
//  RetroOnboardingDemo
//
//  Created by George on 13/10/2025.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let imageSize: CGFloat = 140

struct LogoBounceAnimation: View {
    let startPosition: CGPoint
    @Binding var selected: Int
    let logoBounceItems: [LogoBounceItem]
    let namespace: Namespace.ID
    var isPaused: Bool
    
    @State private var logo: BounceAnimation
    
    init(startPosition: CGPoint, selected: Binding<Int>, logoBounceItems: [LogoBounceItem], namespace: Namespace.ID, isPaused: Bool) {
        self.startPosition = startPosition
        self._selected = selected
        self.logoBounceItems = logoBounceItems
        self.namespace = namespace
        self.isPaused = isPaused
        self.logo = BounceAnimation(
            imageSize: imageSize,
            startPosition: startPosition
        )
    }
    
    var body: some View {
        ZStack {
            Image(logoBounceItems[selected].image)
                .resizable()
                .matchedGeometryEffect(id: "icon", in: namespace)
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize, height: imageSize)
                .position(x: logo.x, y: logo.y)
                .onAppear {
                    logo.onBounce = {
                        selected = (selected + 1) % logoBounceItems.count
                    }
                    
                    restartBounce()
                }
                .onChange(of: isPaused) {
                    if isPaused {
                        logo.stop()
                    } else {
                        restartBounce()
                    }
                }
                .onChange(of: startPosition) {
                   resetLogoPosition()
                }
        }
        .ignoresSafeArea()
    }
    
    private func restartBounce() {
        resetLogoPosition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            logo.start()
        }
    }
    
    private func resetLogoPosition() {
        logo.x = startPosition.x
        logo.y = startPosition.y
    }
}

@Observable @MainActor
class BounceAnimation {
    var x: CGFloat = 40
    var y: CGFloat = 80
    private var imageSize: CGFloat = 0
    
    var onBounce: (() -> Void)?
    
    private let speed: CGFloat = 5.0
    private var direction = CGVector(dx: 1, dy: 1)
    
    private var displayLink: CADisplayLink!
    
    init(imageSize: CGFloat, startPosition: CGPoint = .zero) {
        self.imageSize = imageSize
        self.x = startPosition.x
        self.y = startPosition.y
    }
    
    func start() {
        stop()
        
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .common)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func step(link: CADisplayLink) {
        var newX = x
        var newY = y
        
        newX += direction.dx * speed
        newY += direction.dy * speed
        
        var bounced = false
        let imageRadius = Double(imageSize / 2)
        
        if newX + imageRadius >= screenWidth {
            direction.dx = -1
            bounced = true
        } else if newX - imageRadius <= 0 {
            direction.dx = 1
            bounced = true
        }
        
        if newY + imageRadius >= screenHeight {
            direction.dy = -1
            bounced = true
        } else if newY - imageRadius <= 0 {
            direction.dy = 1
            bounced = true
        }
        
        if bounced {
            onBounce?()
        }
        
        x = newX
        y = newY
    }
}

#Preview {
    @Previewable @State var selected = 0
    @Previewable @Namespace var namespace
    
    var logoBounceItems: [LogoBounceItem] = [
        LogoBounceItem(image: "torus-1", text: "Recap Your Life"),
        LogoBounceItem(image: "torus-2", text: "Week to Week"),
        LogoBounceItem(image: "torus-3", text: "Friends Only"),
        LogoBounceItem(image: "torus-4", text: "Feel Good Social")
    ]
    
    
    LogoBounceAnimation(
        startPosition: CGPoint(x: 200, y: 200),
        selected: $selected,
        logoBounceItems: logoBounceItems,
        namespace: namespace,
        isPaused: false
    )
}
