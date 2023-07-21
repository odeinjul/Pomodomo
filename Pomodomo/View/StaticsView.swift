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
            Button("Add") {
                addRecord(context: context, date: Date.now, count: 1, time: 25)
            }
            Button("Clear Data") {
                clearCoreData(context: context)
            }
            ForEach(history, id: \.self) { day in
                HStack {
                    Text("\(day.count)")
                    Text(day.date != nil ? formatDate(date: day.date!) : "")
                }
            }
        }
    }
}


struct StaticsView_Previews: PreviewProvider {
    static var previews: some View {
        StaticsView()
    }
}
