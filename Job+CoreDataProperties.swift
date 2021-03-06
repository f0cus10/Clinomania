//
//  Job+CoreDataProperties.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/16/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//
//

import Foundation
import CoreData


extension Job {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Job> {
        return NSFetchRequest<Job>(entityName: "Job")
    }

    @NSManaged public var date: Date
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: String
    @NSManaged public var compensation: Double

}
