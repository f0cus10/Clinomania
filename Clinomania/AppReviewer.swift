//
//  StoreReviewSingleton.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/18/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import Foundation
import StoreKit

class AppReviewer {
    static let shared = AppReviewer()
    
    let appLaunchCounter: Int!
    
    private init(){
        let currentCount = UserDefaults.standard.integer(forKey: "appCounter")
        self.appLaunchCounter = currentCount + 1
        UserDefaults.standard.set(self.appLaunchCounter, forKey: "appCounter")
    }
    
    func evaluateReviewRequest(){
        if self.appLaunchCounter > 1 {
            SKStoreReviewController.requestReview()
        }
    }
    
    
}
