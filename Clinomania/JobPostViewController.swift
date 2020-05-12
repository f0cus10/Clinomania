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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitJobButton.layer.cornerRadius = 5.0
        addPhotoButton.layer.cornerRadius = 5.0
        
        //hide keyboard
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitJobPosting(){
        
        if let jobType = jobTypeTextField.text, let location = location {
            // make a jobItem instance
        }
        // display hud
        let successHud = successHudView.hud(containerView: navigationController!.view, animated: true)
        successHud.displayText = "Success"
    }
    
    // MARK: - Helper functions
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        jobTypeTextField.resignFirstResponder()
        rateTextField.resignFirstResponder()
        durationTextField.resignFirstResponder()
    }
}
