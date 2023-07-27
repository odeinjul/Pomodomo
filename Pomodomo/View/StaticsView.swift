//
//  StaticsView.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/21.
//

import SwiftUI

struct StaticsView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PomoCount.date, ascending: true)]) var history: FetchedResults<PomoCount>

    var body: some View {
        VStack {
            // Test part
            StaticsYearView()
            Button("Add") {
                addRecord(context: context, date: Date.now, count: 1, time: 25)
            }
            Button("Clear Data") {
                clearCoreData(context: context)
                for i in 0..<100 {
                    addRecord(context: context, date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!, count: i % 5, time: 25 * (i % 5))
                    //print(Date.now.addingTimeInterval(TimeInterval(-86400 * i)))
                    //print(i % 5)
                    //print(25 * (i % 5))
                }
                print("HI")
            }
            /*
            ForEach(history, id: \.self) { day in
                HStack {
                    Text("\(day.count)")
                    Text(day.date != nil ? formatDate(date: day.date!) : "")
                }
            }
             */
        }
    }
}

struct StaticsWeekView: View {
    let weeks: [String] = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var history: FetchedResults<PomoCount>
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                let records = fetchRecordsForPastWeek(day: Date(), context: context)
                ForEach(weeks.indices, id: \.self) { index in
                    StaticsCircleView(time: records[index], weekDay: weeks[index])
                }
            }
            .padding()
            Text("开启新的连续专注记录")
            Text("你的记录是5天。")
                .foregroundColor(Color("TextGray"))
        }
    }
}

func fetchRecordsForPastWeek(day: Date, context: NSManagedObjectContext) -> [Double] {
    let calendar = Calendar.current
    let today = Date()

    var components = calendar.dateComponents([.year, .weekOfYear], from: today)
    components.weekday = 1
    guard let startDate = calendar.date(from: components) else {
        print("Error calculating start date.")
        return []
    }
    components.weekday = 7
    guard let endDate = calendar.date(from: components) else {
        print("Error calculating end date.")
        return []
    }
    

    let fetchRequest: NSFetchRequest<PomoCount> = PomoCount.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
    do {
        let records = try context.fetch(fetchRequest)
        let weekRecord = (0..<7).map {
            let date = calendar.date(byAdding: .day, value: $0, to: startDate)!
            let dayRecord = records.filter { calendar.isDate($0.date!, inSameDayAs: date) }
            //print(Double((dayRecord.first != nil) ? dayRecord.first!.time : 0))
            return Double((dayRecord.first != nil) ? dayRecord.first!.time : 0)
        }
        return weekRecord
    } catch {
        // Handle the error
        print("Error fetching records: \(error)")
        return []
    }
}


struct StaticsYearView: View {
    @Environment(\.managedObjectContext) var context
    let subDays = (0...52).map { 364 - 7 * $0 }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<subDays.count, id: \.self) { index in
                let subDay = subDays[index]
                let startDate = Calendar.current.date(byAdding: .day, value: -subDay, to: Date())
                let records = fetchRecordsForPastWeek(day: startDate!, context: context)
                StaticsColumnView(intensities: records)
                
            }
        }
    }
}

struct StaticsColumnView: View {
    var intensities: [Double]
    var body: some View {
        VStack(spacing: 4) {
            ForEach(intensities, id: \.self) { intensity in
                StaticsBlockView(intensity: intensity)
            }
        }
    }
}

struct StaticsCircleView: View {
    var time: Double
    var weekDay: String
    var body: some View {
        let color = (time < 25.0) ? Color("StaticsGray") : Color.accentColor
        if time >= 25.0 {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                Text(weekDay)
                    .foregroundColor(Color("BackgroundWhite"))
            }
        }
        else {
            ZStack {
                Circle()
                    .fill(color)
                .frame(width: 40, height: 40)
                Circle()
                    .fill(Color("BackgroundWhite"))
                .frame(width: 35, height: 35)
                Text(weekDay)
                    .foregroundColor(Color("TextGray"))
            }
        }
    }
}


struct StaticsBlockView: View {
    var intensity: Double
    var body: some View {
        let color = intensity < 0 ? Color.clear : ((intensity == 0) ? Color("StaticsGray") : Color.accentColor.opacity(intensity))
        //let borderColor = intensity < 0 ? Color.clear : ((intensity == 0) ? Color("StaticsGray") : Color.accentColor)
        RoundedRectangle(cornerRadius: 3)
            .fill(color)
            //.border(borderColor)
            .frame(width: 10, height: 10)
    }
}

var intensities: [Double] = [0.2, 0.4, 0.8, 0.6, 0, 1.0, 0.4, -1]

struct StaticsView_Previews: PreviewProvider {
    static var previews: some View {
        //StaticsView()
        StaticsBlockView(intensity: 1.0)
        StaticsCircleView(time: 1.0, weekDay: "周一")
        StaticsColumnView(intensities: intensities)
    }
}
