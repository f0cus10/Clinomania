//
//  SecondViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var dataTask: URLSessionDataTask?
    var searchResults = [JobSearchResult]()
    var networkError: Error?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let _ = networkError {
            getJobsNetwork()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getJobsNetwork()
        AppReviewer.shared.evaluateReviewRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Network Helper Functions
    func getJobsNetwork(){
        dataTask?.cancel()
        let url = URL(string: "https://clinomania-backend.f0cus.dev/postedjobs")!
        let session = URLSession.shared
        dataTask = session.dataTask(with: url){
            (data, response, error) in
            if let error = error as NSError?, error.code == -999{
                print("Failure! \(error.localizedDescription)")
                self.showNetworkError()
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseData = data {
                    self.searchResults = self.parse(data: responseData)
                    print("Success! \(String(describing: self.searchResults))")
                    self.searchResults.sort(by: <)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showNetworkError()
            }
        }
        dataTask?.resume()
        
    }
    
    func parse(data: Data) -> [JobSearchResult]{
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(JobArray.self, from: data)
            return result.jobs
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError(){
        let alert = UIAlertController(title: "Oh boy", message: "There was an error accessing the server", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: {
            self.networkError = NSError(domain: "ClinomaniaErrorDomain", code: 1, userInfo: nil)
        })
    }

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JobSearchResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! JobSearchTableViewCell
        cell.configure(for: searchResults[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

