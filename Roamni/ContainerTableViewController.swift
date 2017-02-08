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
class ContainerTableViewController: UITableViewController,CLLocationManagerDelegate{

    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    var tours = [Tour]()
    var filteredTours = [Tour]()
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        //print("the table category is \(self.tourCategory!)")
        super.viewWillAppear(animated)
        tableView.reloadData()

        //tableView
        print("dijici")
        //fetchTours()
      tableView.tableFooterView = UIView()
    }
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        
        ref?.child("tours").observe(.childAdded, with:{ (snapshot) in
            let dictionary = snapshot.value as!  [String : Any]
            // tour.setValuesForKeys(dictionary)
            let location = dictionary["StartPoint"] as!  [String : Any]
            let latitude1 = String(describing: location["lat"]!)
            print("latitude1 is \(latitude1)")
            let latitude = Double(latitude1)
            print("latitude is \(latitude)")
            let longitude1 = String(describing: location["lon"]!)
            let longitude = Double(longitude1)
            //let longitude = (location["lon"] as! NSString).doubleValue
            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            
            let tour = Tour(songid:dictionary["id"] as! Int,category:dictionary["TourType"] as! String, name:dictionary["Name"] as! String,locations:coordinate, desc: dictionary["desc"] as! String, address: dictionary["address"] as! String,star:"1",length:"1",difficulty:"Pleasant")
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            print(tour)
            print("tourn is \(tour.locations)")
            self.tours.removeAll()
            if self.tourCategory == tour.category{
            self.tours.append(tour)
            }
            //self.artworks.removeAll()
            DispatchQueue.main.async(execute: {self.tableView.reloadData() } )
            
        })
        { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tour: Tour
                if searchController.isActive && searchController.searchBar.text != "" {
                    tour = filteredTours[indexPath.row]
                } else {
                    tour = tours[indexPath.row]
                }
                let controller = segue.destination as! DetailViewController
                controller.detailTour = tour
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
        let tour: Tour
        if searchController.isActive && searchController.searchBar.text != "" {
            tour = filteredTours[indexPath.row]
        } else {
            tour = tours[indexPath.row]
        }
        cell.textlabel!.text = tour.name
        cell.detailTextlabel!.text = tour.category
        cell.StarLabel.text = tour.length + " hr"//tour.star
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//        let initialLocation = CLLocation(latitude: tour.locations.latitude, longitude: tour.locations.longitude)
//        let distance = currentlocation.distance(from: initialLocation)
//        let doubleDis : Double = distance
//        let intDis : Int = Int(doubleDis)
//        cell.distanceLabel.text = "\(intDis/1000) km"
        //cell.starrating = CGFloat((tour.star as NSString).floatValue)
        let starView = StarViewController()
        cell.delegate = starView
        cell.Pass()

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
