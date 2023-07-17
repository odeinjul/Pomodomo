//
//  PomodomoUtil.swift
//  Pomodomo
//
//  Created by 吴书让 on 2023/7/17.
//

import Foundation

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (String) {
    let m = seconds / 60, s = (seconds % 3600) % 60
    return (m < 10 ? "0" : "") + "\(m)" + (s < 10 ? ":0" : ":") + "\(s)"
}
