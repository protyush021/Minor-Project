//
//  ActivityProgressView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct ActivityProgressView: View {
    
    @Binding var drawingStroke : Bool
    var delayTime : Double = 0.5
    var animationDuration : Double = 1.5
    
    var body: some View {
        
        Circle()
            .trim(from: 0, to: 1)
            .stroke(lineWidth: 25)
            .fill(.pink.opacity(0.35))
            .padding(20)
            .overlay {
                Circle()
                    .trim(from: 0, to: drawingStroke ? 6/7 : 0)
                    .stroke(.pink,
                            style: StrokeStyle(lineWidth: 25, lineCap: .round))
                    .padding(20)
            }
            .rotationEffect(.degrees(-90))
            .animation(Animation
                .easeOut(duration: animationDuration)
                .delay(delayTime), value: drawingStroke)
    }
}
#Preview {
    ActivityProgressView(drawingStroke: .constant(true))
        .preferredColorScheme(.dark)
}
