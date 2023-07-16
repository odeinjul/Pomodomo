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
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
            Circle()
                .trim(from: 0, to: progress / 2)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
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

struct BlackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(Color(red: 0, green: 0, blue: 0))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}


struct TimerView: View {
    @State var timePassed = 0.0
    @State var timeTotal = 25 * 60.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack (spacing: 25) {
                VStack (spacing: 0) {
                    Text("剩余时间")
                        .font(.system(size: 15, weight: .semibold))
                    Text("\(secondsToHoursMinutesSeconds(Int(timeTotal - timePassed)))")
                        .onReceive(timer) { _ in
                            if timePassed < timeTotal {
                                timePassed += 1.0
                            }
                        }
                        .font(.system(size: 55))
                    Text("（目标：25分钟）")
                        .font(.system(size: 13, weight: .regular))
                }
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName:"backward.end.circle")
                    }
                    .buttonStyle(BlackButton())
                    
                    Button(action: {
                        
                    }) {
                        Text("暂停")
                            .padding(.vertical, 3)
                            .padding(.horizontal, 20)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .buttonStyle(BlackButton())
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName:"arrow.forward.circle")
                    }
                    .buttonStyle(BlackButton())
                }
                .font(.system(size: 20, weight: .medium))
            }
            .offset(y: -80)
            
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
