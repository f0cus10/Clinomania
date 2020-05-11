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
        disablePostJobButton(withMessage: "Post New Job")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocation()
    }
    
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            getLocation()
        }
        if authStatus == .restricted || authStatus == .denied {
            showLocationServicesDeniedAlert()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
    }
    
    // MARK: - CoreLocation Helper Methods
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "The app cannot post jobs without access to location services", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.disablePostJobButton(withMessage: "Location Disabled")
        })
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Helper methods
    func disablePostJobButton(withMessage message: String){
        postJobButton.isEnabled = false
        postJobButton.setTitle(message, for: .disabled)
    }
    
    func enablePostJobButton(withMessage message: String){
        postJobButton.isEnabled = true
        postJobButton.setTitle(message, for: .normal)
    }

}

