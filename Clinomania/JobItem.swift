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
//    var clientID: String?
    var jobType: String = ""
    var totalCompensation: Double = 0.0
    
    class func create(withType: String, compensation: Double) -> JobItem {
        // make an instance, modify, and return
        let instance = JobItem()
        
        instance.jobType = withType
        instance.totalCompensation = compensation
        
        return JobItem()
    }
}
