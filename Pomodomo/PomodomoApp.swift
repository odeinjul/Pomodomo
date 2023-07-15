//
//  PomodomoApp.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/15.
//

import SwiftUI

@main
struct PomodomoApp: App {
    let tabs: [String] = ["Pomodoro", "Statics"]
    @State private var selection: String = "Pomodoro" // Nothing selected by default.
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                    List(tabs, id: \.self, selection: $selection) { tab in
                        NavigationLink(tab.description, value: tab)
                    }
                    .listStyle(.sidebar)
            } detail: {
                PomodomoView()
            }
            .navigationTitle(selection)
        }
    }
}

