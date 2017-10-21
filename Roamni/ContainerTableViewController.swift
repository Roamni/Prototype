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

    let locationManager = CLLocationManager()
    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    var tours = [DownloadTour]()
    var filteredTours = [DownloadTour]()
    var originaltours = [DownloadTour]()
    var originalfilteredTours = [DownloadTour]()
    let searchController = UISearchController(searchResultsController: nil)
    var allTours = [DownloadTour]()
    var numberOfRowsInSection : Int?
    var noDataLabel: UILabel?
    var voicememoLabel: UILabel?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var downloadUsers = [User]()
    var idUsers = [IDUser]()
    var controller : SearchContainerViewController!
    var reviews  = [Review]()
    var customSC : UISegmentedControl!
    var segmentFlag : String!
    //var refreshControl = UIRefreshControl()
    
    func refresh(sender:AnyObject)
    {
        print("refreshing")
        self.tours.removeAll()
        fetchTours()
        self.tableView.reloadData()
        print("\(self.tours.count)???????????")
        self.refreshControl?.endRefreshing()
    }
    
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            if result?.count == 0
            {
                self.activityIndicator.stopAnimating()
                
            }
            for child in result!{
                let dictionary = child.value as!  [String : Any]            // tour.setValuesForKeys(dictionary)
                let startLocation = dictionary["startPoint"] as!  [String : Any]
                let endLocation = dictionary["endPoint"] as!  [String : Any]
                let latitude1 = String(describing: startLocation["lat"]!)
                let latitude = Double(latitude1)
                let longitude1 = String(describing: startLocation["lon"]!)
                let longitude = Double(longitude1)
                let latitude2 = String(describing: endLocation["lat"]!)
                let latitude22 = Double(latitude2)
                let longitude2 = String(describing: endLocation["lon"]!)
                let longitude22 = Double(longitude2)
                let startCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let endCoordinate = CLLocationCoordinate2D(latitude: latitude22!, longitude: longitude22!)
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, mode: dictionary["mode"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "Pleasant", uploadUser: dictionary["uploadUser"] as! String, uploadUserEmail: dictionary["uploadUserEmail"] as! String,tourId: child.key, price: Float(dictionary["price"] as! Float), suburb: dictionary["suburb"] as! String)
                self.tours.append(downloadTour)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                print("\(self.tours[self.tours.count-1].name)!!!!!!")
                print("\(self.tours.count)00000")
            }
            print("\(self.tours.count)1111111")
        })
        print("\(self.tours.count)22222")
    }

        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "")
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
        controller = tabBarController?.viewControllers![1].childViewControllers[0] as! SearchContainerViewController
        controller.tours = self.allTours
//        let locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
//        v.backgroundColor = UIColor.white
//        let segmentedControl = UISegmentedControl(frame:CGRect(x:6, y:5, width: tableView.frame.width - 9, height:24))
//        segmentedControl.insertSegment(withTitle: "one", at: 0, animated: false)
//        segmentedControl.insertSegment(withTitle: "two", at: 1, animated: false)
//        segmentedControl.addTarget(self, action: "changeMode:", for: .valueChanged)
        // Initialize
        let items = ["Walk", "Car", "Transit", "Accessible", "All"]
        self.customSC = UISegmentedControl(items: items)
        
        let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
        if self.segmentFlag == "Walk"{
            customSC.selectedSegmentIndex = 0
        }else if self.segmentFlag == "Car"{
            customSC.selectedSegmentIndex = 1
        }else if self.segmentFlag == "Transit"{
            customSC.selectedSegmentIndex = 2
        }else if self.segmentFlag == "Accessible"{
            customSC.selectedSegmentIndex = 3
        }else if self.segmentFlag == "All"{
            customSC.selectedSegmentIndex = 4
        }
        
        
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(x:0, y:0, width: tableView.frame.width , height:26)
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        customSC.tintColor = UIColor.white
        
        // Add target action method
        customSC.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        //self.view.addSubview(customSC)
        v.addSubview(customSC)
        
        return v
        
    }
    
    
    func changeMode(sender: UISegmentedControl) {
        print("Changing Color to ")
        filteredTours.removeAll()
        tours.removeAll()
        self.filteredTours = self.originalfilteredTours
        self.tours = self.originaltours
       
        switch sender.selectedSegmentIndex {
            
        case 0:
            //self.view.backgroundColor = UIColor.green
            print("Walk")
            //sender.selectedSegmentIndex = 0
//             let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
//            controller.tourCategory = "Walk"
//            textFieldInsideSearchBar.text = "Walk"
//            controller.filterContentForSearchText("Walk", scope: "Tour Name")
            
            var modetours = [DownloadTour]()
            if searchController.isActive && searchController.searchBar.text != "" {
                for tour in filteredTours{
                    if tour.mode == "Walk"{
                       modetours.append(tour)
                    }
                }
               filteredTours.removeAll()
               filteredTours = modetours
               self.tableView.reloadData()
                
            }else{
                for tour in self.originalfilteredTours{
                    if tour.mode == "Walk"{
                        modetours.append(tour)
                    }
                }
                tours.removeAll()
                tours = modetours
                self.tableView.reloadData()
            }

            self.segmentFlag = "Walk"
            
        case 1:
            //self.view.backgroundColor = UIColor.blue
            //sender.selectedSegmentIndex = 1
//             let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
//            controller.tourCategory = "Car"
//            textFieldInsideSearchBar.text = "Car"
//            controller.filterContentForSearchText("Car", scope: "Tour Name")
//            print("Car")
            var modetours = [DownloadTour]()
            if searchController.isActive && searchController.searchBar.text != "" {
                for tour in filteredTours{
                    if tour.mode == "Car"{
                        modetours.append(tour)
                    }
                }
                filteredTours.removeAll()
                filteredTours = modetours
                self.tableView.reloadData()
                
            }else{
                for tour in self.originalfilteredTours{
                    if tour.mode == "Car"{
                        modetours.append(tour)
                    }
                }
                tours.removeAll()
                tours = modetours
                self.tableView.reloadData()
            }
            self.segmentFlag = "Car"
        case 2:
//            sender.selectedSegmentIndex = 2
            //self.view.backgroundColor = UIColor.blue
//             let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
//            controller.tourCategory = "Transit"
//            textFieldInsideSearchBar.text = "Transit"
//            controller.filterContentForSearchText("Transit", scope: "Tour Name")
//            print("Transit")
            var modetours = [DownloadTour]()
            if searchController.isActive && searchController.searchBar.text != "" {
                for tour in filteredTours{
                    if tour.mode == "Transit"{
                        modetours.append(tour)
                    }
                }
                filteredTours.removeAll()
                filteredTours = modetours
                self.tableView.reloadData()
                
            }else{
                for tour in self.originalfilteredTours{
                    if tour.mode == "Transit"{
                        modetours.append(tour)
                    }
                }
                tours.removeAll()
                tours = modetours
                self.tableView.reloadData()
            }
            self.segmentFlag = "Transit"
        case 3:
//            sender.selectedSegmentIndex = 3
//            //self.view.backgroundColor = UIColor.blue
//             let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
//            controller.tourCategory = "Accessible"
//            textFieldInsideSearchBar.text = "Accessible"
//            controller.filterContentForSearchText("Accessible", scope: "Tour Name")
//            print("Accessible")
            var modetours = [DownloadTour]()
            if searchController.isActive && searchController.searchBar.text != "" {
                for tour in filteredTours{
                    if tour.mode == "Accessible"{
                        modetours.append(tour)
                    }
                }
                filteredTours.removeAll()
                filteredTours = modetours
                self.tableView.reloadData()
                
            }else{
                for tour in self.originalfilteredTours{
                    if tour.mode == "Accessible"{
                        modetours.append(tour)
                    }
                }
                tours.removeAll()
                tours = modetours
                self.tableView.reloadData()
            }
            self.segmentFlag = "Accessible"
        case 4:
//            sender.selectedSegmentIndex = 4
//            //self.view.backgroundColor = UIColor.blue
     //let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
//            controller.tourCategory = ""
//            textFieldInsideSearchBar.text = ""
//            controller.filterContentForSearchText("", scope: "Tour Name")
//            print("All")
            //self.segmentFlag = "Accessible"
            var modetours = [DownloadTour]()
            if searchController.isActive && searchController.searchBar.text != "" {
                for tour in filteredTours{
                    if tour.mode != "xxx"{
                        modetours.append(tour)
                    }
                }
                filteredTours.removeAll()
                filteredTours = modetours
                self.tableView.reloadData()
                
            }else{
                for tour in self.originalfilteredTours{
                    if tour.mode != "xxx"{
                        modetours.append(tour)
                    }
                }
                tours.removeAll()
                tours = modetours
                self.tableView.reloadData()
            }
             
             self.segmentFlag = "All"
        default:
            //self.view.backgroundColor = UIColor.purpleColor()
            print("Default")
        }
    }

    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
       // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func viewDidAppear(_ animated: Bool) {
        //print("the table category is \(self.tourCategory!)")
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        if tours.count != 0{
            self.noDataLabel?.text = ""
        }else{
            //self.noDataLabel?.text = "There are no tours in your area. Be the first to create one! Open Voicememos, record and upload!"
        }
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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            print("filter")
            return filteredTours.count
            print("rrrrrrrr")
            //self.numberOfRowsInSection = filteredTours.count
            
        }
        print("tours count\(tours.count)")
        
        return tours.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContainerTableViewCell", for: indexPath) as! ContainerTableViewCell
        let tour: DownloadTour
        
        if searchController.isActive && searchController.searchBar.text != "" {
            tour = filteredTours[indexPath.row]
            //print("rrrrrrrr")
        } else {
            tour = tours[indexPath.row]
            //print("lllllllllll")
        }
        print("careful\(tours.count)")
        for user in downloadUsers{
            //if user.email == tour.uploadUser
        }
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            
            
            for child in result!{
                let dictionary = child.value as!  [String : Any]
                let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                if tour.uploadUserEmail == downloaduser.email{
                    cell.hostLabel.text! = "\(downloaduser.firstname) \(downloaduser.lastname)"
                }
                
                //if
                //self.downloadUsers.append(downloaduser)
                
            }
        }
        )

        var aareviews  = [Review]()
        ref?.child("Reviews").observe(.childAdded, with:{ (snapshot) in
            
            let dictionary = snapshot.value as!  [String : Any]
            let downloadReview = Review(comment: dictionary["review"] as! String, useremail:dictionary["reviewUser"] as! String,tourid: dictionary["tourid"] as! String, star: Float(dictionary["rating"] as! Float))
            if downloadReview.tourid == tour.tourId{
                aareviews.append(downloadReview)
            }
            cell.reviewBtn.setTitle("\(aareviews.count) Review", for: UIControlState.normal)
            
            DispatchQueue.main.async(execute: {} )
        })
//        cell.reviews = aareviews
//        cell.tourId = tour.tourId
//        cell.reviewBtn.addTarget(self, action: "someAction", for: .touchUpInside)
        //aareviews.removeAll()
        
        
        cell.suburbLabel!.text = tour.suburb
        if tour.price != 0{
            cell.priceLabel!.text = "$\(tour.price)"
        }else{
            cell.priceLabel!.text = "Free"
        }
        
        
        cell.textlabel!.text = tour.name
        cell.detailTextlabel!.text = tour.tourType
        cell.StarLabel.text = String(tour.length) + " min"
        cell.modeLabel.text = tour.mode
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
        //var ref:FIRDatabaseReference?
        
       
        
       
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
    
    func fetchUser(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
                let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                //if
                //self.downloadUsers.append(downloaduser)
   
                }
            }
        )
    }
    
   
//    func someAction() {
//        performSegue(withIdentifier: "goToReviews", sender: self)
//    }
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
