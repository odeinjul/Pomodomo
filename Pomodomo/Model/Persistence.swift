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
