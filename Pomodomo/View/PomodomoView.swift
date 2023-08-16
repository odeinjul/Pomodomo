//
//  TimerView.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/15.
//

import SwiftUI
import AVFoundation

var pomodomoCount = 0
var timerColor = Color("PomoRed")

let musicData = NSDataAsset(name: "Ring")!.data
var audioPlayer: AVAudioPlayer?

struct PomodomoView: View {
    @State private var backgroundColor = Color("CardBackground")
    
    var body: some View {
        ScrollView {
            VStack (spacing: 40){
                VStack (alignment: .leading, spacing: 5){
                    Text("Pomo")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("再早一点，再早一点进入摸鱼时间！")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("TextGray"))
                    Spacer()
                    TimerView(colorChangeAction: { newColor in
                        self.changeBackgroundColor(newColor)
                    })
                    .padding(30)
                    .background(backgroundColor)
                    //.animation(.easeInOut, value: backgroundColor)
                    .cornerRadius(12)
                    .clipped()
                    .shadow(color: Color("ShadowGray").opacity(0.5), radius: 15)
                }
                .padding(.horizontal, 50)
                StaticsView()
                    .padding(30)
                    .background(backgroundColor)
                    //.animation(.easeInOut, value: backgroundColor)
                    .cornerRadius(12)
                    .clipped()
                    .padding(.horizontal, 50)
                    .shadow(color: Color("ShadowGray").opacity(0.5), radius: 15)
            }
            .padding(.vertical, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundWhite"))
    }
    
    func changeBackgroundColor(_ newColor: Color) {
            backgroundColor = newColor
    }
}

struct TimerView: View {
    @StateObject var pomodomoCurrent = Pomodomo(type: .Pomo)
    @Environment(\.managedObjectContext) var context
    @State var backgroundColor = Color.black
    @State var stop = true
    
    var colorChangeAction: (Color) -> Void
    
    var body: some View {
        VStack (spacing: 10){
            Spacer()
            ZStack {
                VStack (spacing: 25) {
                    PomodomoTextView(
                        pomodomoCurrent: pomodomoCurrent,
                        stop: $stop,
                        colorChangeAction: colorChangeAction
                    )
                    PomodomoButtonView(
                        pomodomoCurrent: pomodomoCurrent,
                        stop: $stop,
                        colorChangeAction: colorChangeAction
                    )
                    
                }
                CircularProgressView(progress: pomodomoCurrent.timePassed / pomodomoCurrent.timeTotal)
            }
            .frame(minWidth: 650, maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            Divider()
            StaticsWeekView()
            Spacer()
        }
        .offset(y: 20)
        .frame(minWidth: 650, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
    }
}

struct PomodomoButtonView: View {
    @ObservedObject var pomodomoCurrent: Pomodomo
    @Binding var stop: Bool
    @Environment(\.managedObjectContext) var context
    var colorChangeAction: (Color) -> Void
    
    var body: some View {
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
                addRecord(context: context, date: Date.now, count: 1, time: 0)
                NextPomo(pomodomoCurrent: pomodomoCurrent, stop: &stop, colorChangeAction: colorChangeAction)
            }) {
                Image(systemName:"arrow.forward.circle")
            }
            .buttonStyle(BlackButton())
        }
        .font(.system(size: 20, weight: .medium))
    }
}

struct PomodomoTextView: View {
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var pomodomoCurrent: Pomodomo
    @Binding var stop: Bool
    @Environment(\.managedObjectContext) var context
    var colorChangeAction: (Color) -> Void
    
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
                Text(pomodomoCurrent.type.simpleDescription())
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .foregroundColor(timerColor)
                    .font(.system(size: 20, weight: .black))
                    //.background(RoundedRectangle(cornerRadius: 5)
                    //  .fill(timerColor))
                //Divider()
                Text("剩余时间")
                    .font(.system(size: 17, weight: .bold))
            }
            Text("\(secondsToHoursMinutesSeconds(Int(pomodomoCurrent.timeTotal - pomodomoCurrent.timePassed)))")
                .onReceive(timer) { _ in
                    //print(pomodomoCurrent.timePassed)
                    if (pomodomoCurrent.timePassed < pomodomoCurrent.timeTotal && !stop)  {
                        pomodomoCurrent.timePassed += 1.0
                    }
                    else if(pomodomoCurrent.timePassed == pomodomoCurrent.timeTotal) {
                        do{
                            audioPlayer = try AVAudioPlayer(data: musicData)
                            audioPlayer?.play()
                        }catch{
                            print("Failed to play sound")
                        }
                        if(pomodomoCurrent.type == PomodomoType.Pomo) {
                            addRecord(context: context, date: Date.now, count: 1, time: 25)
                        }
                        NextPomo(pomodomoCurrent: pomodomoCurrent, stop: &stop, colorChangeAction: colorChangeAction)
                    }
                }
                .font(.system(size: 55))
            Text("（目标：25分钟）")
                .font(.system(size: 11, weight: .regular))
        }
    }
}

func NextPomo (pomodomoCurrent: Pomodomo, stop: inout Bool, colorChangeAction:  @escaping (Color) -> Void)-> Void {
    stop = true
    pomodomoCount += 1
    pomodomoCount %= 8
    if (pomodomoCount == 7) {
        pomodomoCurrent.setType(.LongRelax)
    } else if (pomodomoCount % 2 == 0) {
        pomodomoCurrent.setType(.Pomo)
    } else {
        pomodomoCurrent.setType(.SmallRelax)
    }
    timerColor = pomodomoCurrent.color
    pomodomoCurrent.timePassed = 0
    /*
    withAnimation {
        colorChangeAction(timerColor)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation {
            colorChangeAction(Color("CardBackground"))
        }
    }
     */
}

struct PomodomoView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5)
        PomodomoView()
    }
}
