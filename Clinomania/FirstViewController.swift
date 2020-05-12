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
        
        updateButton()
        let buttonTitleColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        postJobButton.setTitleColor(buttonTitleColor, for: .normal)
        postJobButton.setTitleColor(buttonTitleColor, for: .disabled)
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
        
        // start the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updateButton()
    }
    
    func stopLocationManager(){
        if locationUpdateInProgress {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            locationUpdateInProgress = false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("didFailWithError \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
        updateButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distanceFromCurrent = CLLocationDistance(Double.greatestFiniteMagnitude)
        
        if let location = currentLocation {
            distanceFromCurrent = newLocation.distance(from: location)
        }
        
        if currentLocation == nil || currentLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            currentLocation = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
            }
            updateButton()
        }
        else if distanceFromCurrent < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(currentLocation!.timestamp)
            
            if timeInterval > 10 {
                stopLocationManager()
                updateButton()
            }
        }
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
    func updateButton(){
        if let _ = currentLocation {
            enablePostJobButton(withMessage: "Post New Job")
        }
        else if locationUpdateInProgress {
            disablePostJobButton(withMessage: "Searching")
        }
        else {
            disablePostJobButton(withMessage: "Error")
        }
    }
    
    func disablePostJobButton(withMessage message: String){
        postJobButton.setTitle(message, for: .disabled)
        postJobButton.isEnabled = false
        postJobButton.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
    }
    
    func enablePostJobButton(withMessage message: String){
        postJobButton.setTitle(message, for: .normal)
        postJobButton.isEnabled = true
        postJobButton.backgroundColor = UIColor(red: 0.27, green: 0.48, blue: 0.62, alpha: 1.00)
    }

}

