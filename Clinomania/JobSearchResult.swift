//
//  JobSearchResult.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/17/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import Foundation

class JobArray: Codable {
    var jobCount: Int? = 0
    var jobs = [JobSearchResult]()
}

class JobSearchResult: Codable {
    var id: Int?
    var type: String = ""
    var latitude: Double?
    var longitude: Double?
    var compensation: Double?
}

func < (lhs: JobSearchResult, rhs: JobSearchResult) -> Bool {
    return lhs.type.localizedStandardCompare(rhs.type) == .orderedDescending
}
