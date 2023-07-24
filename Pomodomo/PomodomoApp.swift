//
//  PomodomoApp.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/15.
//

import SwiftUI
import CoreData

@main
struct PomodomoApp: App {
    
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "PomodataModel")

        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
    }
    
    
    
    let tabs: [String] = ["Pomodoro", "Statics"]
    @State private var selection: String = "Pomodoro"   
    var body: some Scene {
        WindowGroup {
            PomodomoView()
                .environment(\.managedObjectContext, container.viewContext)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

