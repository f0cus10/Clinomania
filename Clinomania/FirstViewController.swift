//
//  FirstViewController.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/8/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatterInstance = DateFormatter()
    formatterInstance.dateStyle = .medium
    formatterInstance.timeStyle = .short
    return formatterInstance
}()

class FirstViewController: UIViewController, CLLocationManagerDelegate, JobPostViewControllerDelegate {
    
    @IBOutlet weak var postJobButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // CoreLocation variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationUpdateInProgress = false
    var lastLocationError: Error?
    
    // CoreLocation Deadline
    var timer: Timer?
    
    // CoreData variable
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Job> = {
        let fetchRequest = NSFetchRequest<Job>()
        
        let entity = Job.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.fetchBatchSize = 20
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Jobs")
        controller.delegate = self
        return controller
    }()
    
    // Date
    var currentDate = Date()
    
    deinit {
        fetchedResultsController.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postJobButton.layer.cornerRadius = 5.0
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        
        
        updateButton()
        let buttonTitleColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        postJobButton.setTitleColor(buttonTitleColor, for: .normal)
        postJobButton.setTitleColor(buttonTitleColor, for: .disabled)
        
        performDataFetch()
        
        // add a GCD dispatch
        afterDelay(0.4, run: {
            self.getLocation()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopLocationManager()
    }
    
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            //retake authStatus
            return
        }
        
        if authStatus == .restricted || authStatus == .denied {
            showLocationServicesDeniedAlert()
        }
        
        if CLLocationManager.locationServicesEnabled() && !locationUpdateInProgress{
            // start the location manager
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationUpdateInProgress = true
            updateButton()
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
        
    }
    
    func stopLocationManager(){
        if locationUpdateInProgress {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            locationUpdateInProgress = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization changed")
        getLocation()
    }
    
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
            afterDelay(0.2){
                self.updateButton()
            }
        }
        else if distanceFromCurrent < 2 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(currentLocation!.timestamp)
            
            if timeInterval > 5 {
                print("*** Cutting Off")
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
        stopLocationManager()
        if segue.identifier == "JobPostDetails" {
            let controller = segue.destination as! JobPostViewController
            controller.delegate = self
            controller.location = currentLocation
        }
    }
    
    // MARK: - JobPostViewControllerDelegate methods
    func postNewJobOrder(_ controller: JobPostViewController, didFinishCreating item: JobItem) {
        print("*** the job item's type was: \(item.jobType)")
        if let location = currentLocation {
            let _ = Job.makeJob(withContext: managedObjectContext, jobType: item.jobType, formattedDate: currentDate, coordinate: location.coordinate)
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
        stopLocationManager()
        print("didFinishCreating \(item)")
    }
    
    // MARK: - UI Helper methods
    func updateButton(){
        // TODO: refactor
        if let _ = currentLocation {
            enablePostJobButton(withMessage: "Post New Job")
        } else {
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    disablePostJobButton(withMessage: "Location Disabled")
                } else {
                    disablePostJobButton(withMessage: "Location Error")
                }
            } else if !CLLocationManager.locationServicesEnabled(){
                disablePostJobButton(withMessage: "Location Disabled")
            } else if locationUpdateInProgress {
                disablePostJobButton(withMessage: "Searching")
            } else {
                disablePostJobButton(withMessage: "Initializing")
            }
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
    
    // MARK: - Timer function
    @objc func didTimeOut(){
        if currentLocation == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "ClinomaniaErrorDomain", code: 1, userInfo: nil)
            updateButton()
        }
    }
    
    // MARK: - Helper function
    func format(date givenDate: Date) -> String {
        return dateFormatter.string(from: givenDate)
    }
    
    func performDataFetch(){
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateJobCell", for: indexPath) as! JobTableViewCell
        
        let job = fetchedResultsController.object(at: indexPath)
        
        cell.configure(for: job)
        return cell
    }
}

extension FirstViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? JobTableViewCell {
                let updatedJob = controller.object(at: indexPath!) as! Job
                cell.configure(for: updatedJob)
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
