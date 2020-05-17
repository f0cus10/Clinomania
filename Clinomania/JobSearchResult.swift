//
//  JobSearchResult.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/17/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import Foundation

class JobArray: Codable {
    var resultCount = 0
    var results = [JobSearchResult]()
}

class JobSearchResult: Codable {
    var jobID: Int?
    var jobType: String?
    var latitude: Double?
    var longitude: Double?
    var compensation: Double?
}
