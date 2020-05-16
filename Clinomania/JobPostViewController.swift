//
//  JobPostViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/9/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit
import CoreLocation

protocol JobPostViewControllerDelegate: class {
    func postNewJobOrder(_ controller: JobPostViewController, didFinishCreating item: JobItem)
}

class JobPostViewController: UIViewController {
    
    weak var delegate: JobPostViewControllerDelegate?
    
    var location: CLLocation?
    
    @IBOutlet weak var submitJobButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitJobButton.layer.cornerRadius = 5.0
        addPhotoButton.layer.cornerRadius = 5.0
        
        updateLocationFields()
        //hide keyboard
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitJobPosting(){
        
        if let jobType = jobTypeTextField.text, let rateString = rateTextField.text, let durationString = durationTextField.text {
            
            if let rate = Double(rateString), let duration = Double(durationString) {
                let job = JobItem.create(withType: jobType, compensation: rate*duration)
                
                delegate?.postNewJobOrder(self, didFinishCreating: job)
            }
        }
        // display hud
        let successHud = successHudView.hud(containerView: navigationController!.view, animated: true)
        successHud.displayText = "Success"
        
        afterDelay(0.6){
            successHud.hide(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Helper functions
    func updateLocationFields(){
        if let location = location {
            latitudeField.text = String(coordinate: location.coordinate.latitude)
            longitudeField.text = String(coordinate: location.coordinate.longitude)
        }
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        jobTypeTextField.resignFirstResponder()
        rateTextField.resignFirstResponder()
        durationTextField.resignFirstResponder()
    }
}

extension String {
    init(coordinate: CLLocationDegrees){
        self.init(format: "%.8f", coordinate)
    }
}
