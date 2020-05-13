//
//  Functions.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/12/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import Foundation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .localDomainMask)
    return paths.first!
}()

func afterDelay(_ seconds: Double, run: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
