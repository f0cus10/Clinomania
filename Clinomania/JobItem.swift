//
//  JobItem.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/12/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import Foundation
import CoreLocation

class JobItem: NSObject {
    var clientID: String?
    var jobType: String = ""
    var location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var totalCompensation: Double = 0.0
    
    func createWorkOrder(clientID: String?, jobType: String, location: CLLocationCoordinate2D, totalCompensation: Double) -> JobItem {
        let instance = JobItem()
        instance.clientID = clientID
        instance.jobType = jobType
        instance.location = location
        instance.totalCompensation = totalCompensation
        return instance
    }
}
