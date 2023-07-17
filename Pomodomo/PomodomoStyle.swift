//
//  PomodomoStyle.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/17.
//

import SwiftUI

struct BlackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .foregroundStyle(.white)
            .background(configuration.isPressed ? .black.opacity(0.65) : .black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    Color("Gray"),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
            Circle()
                .trim(from: 0, to: progress / 2)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
        }
        .frame(width:450, height: 500)
        .rotationEffect(.degrees(180))
        .animation(.easeOut, value: progress)
        .offset(y: 75)
    }
}
