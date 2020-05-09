//
//  JobPostViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/9/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class JobPostViewController: UIViewController {
    @IBOutlet weak var submitJobButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitJobButton.layer.cornerRadius = 5.0
        addPhotoButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitJobPosting(){
        navigationController?.popViewController(animated: true)
    }
}
