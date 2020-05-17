//
//  SecondViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var searchResults: [JobSearchResult]!

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
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseData = data {
                    self.searchResults = self.parse(data: responseData)
                    print("Success! \(responseData)")
                }
            } else {
                print("Failure! \(response!)")
            }
        }
        dataTask.resume()
        
    }
    
    func parse(data: Data) -> [JobSearchResult]{
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(JobArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }

}

