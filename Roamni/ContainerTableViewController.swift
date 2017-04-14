//
//  ContainerTableViewController.swift
//  Roamni
//
//  Created by Hyman Li on 18/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class ContainerTableViewController: UITableViewController, CLLocationManagerDelegate, FloatRatingViewDelegate{



    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    var tours = [DownloadTour]()
    var filteredTours = [DownloadTour]()
    let searchController = UISearchController(searchResultsController: nil)
    var allTours = [DownloadTour]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
       // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func viewDidAppear(_ animated: Bool) {
        //print("the table category is \(self.tourCategory!)")
        super.viewWillAppear(animated)
        tableView.reloadData()

        //tableView
        //fetchTours()
      //tableView.tableFooterView = UIView()
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        tableView.tableFooterView = footerView
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tour: DownloadTour
                if searchController.isActive && searchController.searchBar.text != "" {
                    tour = filteredTours[indexPath.row]
                    allTours = filteredTours
                } else {
                    tour = tours[indexPath.row]
                    allTours = tours
                    
                }
//                let navController = segue.destination as! UINavigationController
               
                let controller = segue.destination as! DetailViewController
                controller.detailTour = tour
                controller.currentIndex = indexPath.row
                controller.allDetailTour = allTours
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredTours.count
        }
        return tours.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContainerTableViewCell", for: indexPath) as! ContainerTableViewCell
        let tour: DownloadTour
        if searchController.isActive && searchController.searchBar.text != "" {
            tour = filteredTours[indexPath.row]
        } else {
            tour = tours[indexPath.row]
        }
        cell.textlabel!.text = tour.name
        cell.detailTextlabel!.text = tour.tourType
        cell.StarLabel.text = String(tour.length) + " min"
        //tour.star
        cell.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        cell.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        cell.floatRatingView.delegate = self
        cell.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        cell.floatRatingView.maxRating = 5
        cell.floatRatingView.minRating = 1
        //Set star rating
        cell.floatRatingView.rating = tour.star
        cell.floatRatingView.editable = false

        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let initialLocation = CLLocation(latitude: tour.startLocation.latitude, longitude: tour.startLocation.longitude)
        let distance = currentlocation.distance(from: initialLocation)
        let doubleDis : Double = distance
        let intDis : Int = Int(doubleDis)
        cell.distanceLabel.text = "\(intDis/1000) km"
        cell.starrating = CGFloat(tour.star)
        return cell
    }
    
//    func filterContentForSearchText(_ searchText: String, scope: String = "Default") {
//        filteredTours = tours.filter({( tour : Tour) -> Bool in
//            let categoryMatch = (scope == "Default") || (tour.category == scope)
//            return categoryMatch && tour.name.lowercased().contains(searchText.lowercased())
//        })
//        tableView.reloadData()
//    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}

//extension ContainerTableViewController: UISearchBarDelegate {
//    // MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
//    }
//}
//
//extension ContainerTableViewController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
//    }
//}
