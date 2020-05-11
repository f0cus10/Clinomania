//
//  FirstViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var postJobButton: UIButton!
    
    // CoreLocation variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationUpdateInProgress = true
    var lastLocationError: Error?
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postJobButton.layer.cornerRadius = 5.0
        updateJobButton()
    }
    
    func updateJobButton(){
        if locationUpdateInProgress {
            // location is still updating
            postJobButton.setTitle("Searching", for: .disabled)
            postJobButton.isEnabled = false
        }
        // location has either errored or found
        else if let location = currentLocation {
            print(location)
            postJobButton.setTitle("Post New Job", for: .normal)
            postJobButton.isEnabled = true
        } else {
            postJobButton.setTitle("Error", for: .highlighted)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

