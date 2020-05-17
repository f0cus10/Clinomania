//
//  SecondViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var searchResults: JobArray!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getJobsNetwork()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Network Helper Functions
    func getJobsNetwork(){
        let url = URL(string: "http://clinomania-backend.f0cus.dev/postedjobs")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url){
            (data, response, error) in
            if let error = error {
                print("Failure! \(error.localizedDescription)")
            } else {
                print("Success! \(response!)")
            }
        }
        dataTask.resume()
        
    }

}

