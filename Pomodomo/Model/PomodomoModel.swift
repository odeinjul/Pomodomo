//
//  PomodomoModel.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/17.
//

import Foundation
import SwiftUI


enum PomodomoType: String {
    case Pomo, SmallRelax, LongRelax
    func simpleDescription() -> String {
        switch self {
        case .Pomo:
            return "Pomo"
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
    @Published var color: Color
    
    init(type: PomodomoType) {
        self.type = type
        
        switch type {
        case .Pomo:
            self.timeTotal = 25 * 60.0
            self.color = Color("PomoRed")
        case .SmallRelax:
            self.timeTotal = 4//5 * 60.0
            self.color = Color("PomoGreen")
        case .LongRelax:
            self.timeTotal = 15 * 60.0
            self.color = Color("PomoBlue")
        }
        
        self.timePassed = 0.0
    }
    
    func setType(_ newType: PomodomoType) {
        type = newType
        
        switch newType {
        case .Pomo:
            self.timeTotal = 25 * 60.0
            self.color = Color("PomoRed")
        case .SmallRelax:
            self.timeTotal = 4//5 * 60.0
            self.color = Color("PomoGreen")
        case .LongRelax:
            self.timeTotal = 15 * 60.0
            self.color = Color("PomoBlue")
        }
        
        timePassed = 0.0
    }
}
