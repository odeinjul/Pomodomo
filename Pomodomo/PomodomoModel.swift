//
//  PomodomoModel.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/17.
//

import Foundation


enum PomodomoType: String {
    case Pomo, SmallRelax, LongRelax
    func simpleDescription() -> String {
        switch self {
        case .Pomo:
            return "番茄钟"
        case .SmallRelax:
            return "短休息"
        case .LongRelax:
            return "长休息"
        }
    }
}

class Pomodomo: ObservableObject{
    @Published var type: PomodomoType
    @Published var timeTotal: Double
    @Published var timePassed: Double
    
    init(type: PomodomoType) {
        self.type = type
        
        switch type {
        case .Pomo:
            self.timeTotal = 25 * 60.0
        case .SmallRelax:
            self.timeTotal = 5 * 60.0
        case .LongRelax:
            self.timeTotal = 15 * 60.0
        }
        
        self.timePassed = 0.0
    }
    
    func setType(_ newType: PomodomoType) {
        type = newType
        
        switch newType {
        case .Pomo:
            timeTotal = 25 * 60.0
        case .SmallRelax:
            timeTotal = 5 * 60.0
        case .LongRelax:
            timeTotal = 15 * 60.0
        }
        
        timePassed = 0.0
    }
}
