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
                let count = 3
                let time = 45
                let date = createDateOnly(year: 2023, month: 7, day: 20)
                if let existingRecord = fetchRecord(for: date) {
                    existingRecord.count += Int16(count)
                    existingRecord.time += Int16(time)
                } else {
                    let day = PomoCount(context: context)
                    day.date = date
                    day.count = Int16(count)
                    day.time = Int16(time)
                }
                try! context.save()
            }
            Button("Clear Data") {
                clearCoreData()
            }
            ForEach(history, id: \.self) { day in
                HStack {
                    Text("\(day.count)")
                    Text(day.date != nil ? formatDate(date: day.date!) : "")
                }
            }
        }
    }
    
    private func clearCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PomoCount.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            // Handle the error
            print("Error clearing Core Data: \(error)")
        }
    }
    
    private func fetchRecord(for date: Date) -> PomoCount? {
        let fetchRequest: NSFetchRequest<PomoCount> = PomoCount.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching records: \(error)")
            return nil
        }
    }
    
    private func formatDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
    }
    
    private func createDateOnly(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
    }
}


struct StaticsView_Previews: PreviewProvider {
    static var previews: some View {
        StaticsView()
    }
}
