//
//  SignInViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
    }
}
