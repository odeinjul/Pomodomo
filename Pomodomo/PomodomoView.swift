//
//  TimerView.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/15.
//

import SwiftUI

struct TimerView: View {
    @State var pomodomoCount = 0
    @StateObject var pomodomoCurrent = Pomodomo(type: .Pomo)
    @State var stop = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack (spacing: 25) {
                VStack (spacing: 0) {
                    HStack {
                        Text(pomodomoCurrent.type.simpleDescription())
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(.black))
                        Text("剩余时间")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    Text("\(secondsToHoursMinutesSeconds(Int(pomodomoCurrent.timeTotal - pomodomoCurrent.timePassed)))")
                        .onReceive(timer) { _ in
                            if (pomodomoCurrent.timePassed <= pomodomoCurrent.timeTotal && !stop)  {
                                pomodomoCurrent.timePassed += 1.0
                                print((secondsToHoursMinutesSeconds(Int(pomodomoCurrent.timeTotal - pomodomoCurrent.timePassed))))
                                
                            }
                        }
                        .font(.system(size: 55))
                    Text("（目标：25分钟）")
                        .font(.system(size: 13, weight: .regular))
                }
                
                HStack {
                    Button(action: {
                        pomodomoCurrent.timePassed = 0.0
                        stop = true
                    }) {
                        Image(systemName:"backward.end.circle")
                    }
                    .buttonStyle(BlackButton())
                    
                    Button(action: {
                        stop = !stop
                    }) {
                        Text(stop ? "继续" : "暂停")
                            .padding(.vertical, 3)
                            .padding(.horizontal, 20)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .buttonStyle(BlackButton())
                    
                    Button(action: {
                        pomodomoCount += 1
                        pomodomoCount %= 8
                        if (pomodomoCount == 7) {
                            pomodomoCurrent.setType(.LongRelax)
                        } else if (pomodomoCount % 2 == 0) {
                            pomodomoCurrent.setType(.Pomo)
                        } else {
                            pomodomoCurrent.setType(.SmallRelax)
                        }
                        stop = true
                    }) {
                        Image(systemName:"arrow.forward.circle")
                    }
                    .buttonStyle(BlackButton())
                }
                .font(.system(size: 20, weight: .medium))
            }
            .offset(y: 0)
            
            CircularProgressView(progress: pomodomoCurrent.timePassed/pomodomoCurrent.timeTotal)
        }
        .frame(minWidth: 650, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
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
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct PomodomoView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5)
        PomodomoView()
    }
}
