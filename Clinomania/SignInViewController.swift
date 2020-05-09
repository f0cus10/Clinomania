//
//  SignInViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // hide keyboard
        let keyboardDismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(keyboardDismissRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Helper functions
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return
    }
}
