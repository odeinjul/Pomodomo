//
//  TimerView.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/15.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    Color("Gray"),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
        }
        .rotationEffect(.degrees(180))
        .animation(.easeInOut, value: progress)
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (String) {
    let m = seconds / 60, s = (seconds % 3600) % 60
    return (m < 10 ? "0" : "") + "\(m)" + (s < 10 ? ":0" : ":") + "\(s)"
}

struct TimerView: View {
    @State var timePassed = 0.0
    @State var timeTotal = 25 * 60.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Text("\(secondsToHoursMinutesSeconds(Int(timeTotal - timePassed)))")
                .onReceive(timer) { _ in
                    if timePassed < timeTotal {
                        timePassed += 1.0
                    }
                }
                .font(.system(size: 60))
                .offset(y: -23)
            
            CircularProgressView(progress: timePassed/timeTotal)
        }
    }
}

struct PomodomoView: View {
    var body: some View {
        ZStack{
            TimerView()
            .padding(30)
            .background(.white)
            .cornerRadius(8)
            .clipped()
            .shadow(color: .gray.opacity(0.3), radius: 20)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct PomodomoView_Previews: PreviewProvider {
    static var previews: some View {
        PomodomoView()
    }
}
