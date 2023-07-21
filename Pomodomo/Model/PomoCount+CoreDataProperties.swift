//
//  PomoCount+CoreDataProperties.swift
//  Pomodomo
//
//  Created by Ode on 2023/7/20.
//
//

import Foundation
import CoreData


extension PomoCount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PomoCount> {
        return NSFetchRequest<PomoCount>(entityName: "PomoCount")
    }

    @NSManaged public var date: Date?
    @NSManaged public var count: Int16
    @NSManaged public var time: Int16

}

extension PomoCount : Identifiable {

}
