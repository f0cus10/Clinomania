//
//  Job+CoreDataClass.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/16/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//
//

import Foundation
import CoreLocation
import CoreData

@objc(Job)
public class Job: NSManagedObject {
    class func makeJob(withContext: NSManagedObjectContext, jobType: String, formattedDate: Date, coordinate: CLLocationCoordinate2D) -> Job {
           let instance = Job(context: withContext)
           instance.type = jobType
           instance.date = formattedDate
           instance.longitude = coordinate.longitude
           instance.latitude = coordinate.latitude
           return instance
       }
}
