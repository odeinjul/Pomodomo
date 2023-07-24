//
//  Persistence.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/20.
//

import CoreData

func saveCountSample(context: NSManagedObjectContext) {
    let date = Date()
    let count = 3
    let time = 45
    let dailyCount = PomoCount(context: context)
    dailyCount.date = date
    dailyCount.count = Int16(count)
    dailyCount.time = Int16(time)
    do {
        try context.save()
    }
    catch {
        print(error.localizedDescription)
    }
}

func clearCoreData(context: NSManagedObjectContext) {
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

func addRecord(context: NSManagedObjectContext, date: Date, count: Int, time: Int) {
    let date = createDateOnly(date: date)
    if let existingRecord = fetchRecord(context: context, for: date) {
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

func fetchRecord(context: NSManagedObjectContext, for date: Date) -> PomoCount? {
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

func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
}

func createDateOnly(date: Date) -> Date {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return calendar.date(from: components) ?? Date()
}
