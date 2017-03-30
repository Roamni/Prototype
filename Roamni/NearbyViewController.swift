//
//  NearbyViewController.swift
//  Roamni
//
//  Created by Hyman Li on 4/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import ReachabilitySwift
class NearbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate{

    let reachability = Reachability()!


    
    @IBOutlet weak var tableView: UITableView!
    var place : TourForMap?
    var tours = [DownloadTour]()
    var tourInFive = [DownloadTour]()
    var controller : SearchContainerViewController!
    var locationManager = CLLocationManager()

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
         self.tableView.dataSource = self
         self.tableView.delegate = self
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
            self.tableView.reloadData()
             //self.fetchTours()
        })
        self.tours.removeAll()
        fetchTours()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        
        controller = tabBarController?.viewControllers![1].childViewControllers[0] as! SearchContainerViewController
        //change here to apply 5 km
        
        controller.tours = tours
        locationManager.startUpdatingLocation()
    }
    
//    override func viewDidLoad() {
//
//        fetchTours()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//         navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
//         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
// 
//        controller = tabBarController?.viewControllers![1].childViewControllers[0] as! SearchContainerViewController
//        //change here to apply 5 km
//        
//        controller.tours = tours
//        locationManager.startUpdatingLocation()
//    }
//    
//    
    
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        controller = tabBarController?.viewControllers![1].childViewControllers[0] as! SearchContainerViewController
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
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
            
            //let longitude = (location["lon"] as! NSString).doubleValue
            let startCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let endCoordinate = CLLocationCoordinate2D(latitude: latitude22!, longitude: longitude22!)
            
            let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["length"] as! String, difficulty: "Pleasant", uploadUser: dictionary["uploadUser"] as! String,tourId: child.key)
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
            //self.artworks.removeAll()
            print(startCoordinate)
                    self.tours.append(downloadTour)
            
                        //change here to apply 5 km
            
            self.controller.tours = self.tours
            self.controller.getTableVCObject?.tours = self.controller.tours
            self.controller.getTableVCObject?.tableView.reloadData()
            }
            })
    
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let locValue:CLLocationCoordinate2D = location.coordinate
            let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            for tour in tours{
                let initialLocation = CLLocation(latitude: tour.startLocation.latitude, longitude: tour.startLocation.longitude)
                let distance = currentlocation.distance(from: initialLocation)
                if distance < 5000 {
                    
                    tourInFive.append(tour)
                }
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 // your number of cell here
        switch(section)
        {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 1
        case 5: return 1
        case 6: return 1
        case 7: return 1
        case 8: return 1
        default: return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        // #warning Incomplete implementation, return the number of sections
        return 9
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.0000001
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        if indexPath.section == 0{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 1{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 2{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 3{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 4{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 5{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 6{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 7{
            return 50.0//Choose your custom row height
        }
        if indexPath.section == 8{
            return 50.0//Choose your custom row height
        }

        
        return 50.0
    }
    
    
    
    //This function returns a cell for a table view, the returned object is of
    //type UITableViewCell. These are the objects that users see in the table's rows.
    //This function basically returns a cell, for a table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section == 0{
            //Return the cell with identifier NotificationTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalkingTableViewCell", for: indexPath as IndexPath) as! WalkingTableViewCell
            return cell
        }
        else if indexPath.section == 1{
            //Return the cell with identifier BackTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrivingTableViewCell", for: indexPath as IndexPath) as! DrivingTableViewCell
            return cell
            
        }else if indexPath.section == 2{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CyclingTableViewCell", for: indexPath as IndexPath) as! CyclingTableViewCell
            return cell
            
            
        }else if indexPath.section == 3{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingTableViewCell", for: indexPath as IndexPath)
            as! ShopTableViewCell
            return cell
            
            
        }else if indexPath.section == 4{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RealEstateTableViewCell", for: indexPath as IndexPath)
            as! RealTableViewCell
            return cell
            
            
        }else if indexPath.section == 5{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccTableViewCell", for: indexPath as IndexPath)
            as! AccTableViewCell
            return cell
            
            
        }else if indexPath.section == 6{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath as IndexPath)
            as! MoreTableViewCell
            return cell
            
            
        }else if indexPath.section == 7{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecomTableViewCell", for: indexPath as IndexPath)
            as! RecomTableViewCell
            return cell
            
            
        }else {
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreTableViewCell", for: indexPath as IndexPath)
            as! PreTableViewCell
            return cell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        switch(section) {
        case 0:return "  "
        case 6:return "  "
            
        default :return ""

    }
    
    }
    // pass selected artwokr to detail view
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "searchSegue"
//        {
//            
//            let indexPath = self.tableView.indexPathForSelectedRow!
//            let controller: SearchContainerViewController = segue.destination
//                as! SearchContainerViewController
//           // let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            //let controller = storyboard.instantiateViewController(withIdentifier: "SearchContainerViewController") as! SearchContainerViewController
//            // controller.testtest = "yesyesyes"
//          // controller.testtest = "111111111"
//            
//                }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
        tabBarController?.selectedIndex = 1
        if indexPath.section == 0{
            controller.tourCategory = "walking"
            textFieldInsideSearchBar.text = "walking"
            controller.filterContentForSearchText("walking", scope: "Default")
        }else if indexPath.section == 1{
            controller.tourCategory = "driving"
            textFieldInsideSearchBar.text = "driving"
            controller.filterContentForSearchText("driving", scope: "Default")
        }else if indexPath.section == 2{
            controller.tourCategory = "cycling"
            textFieldInsideSearchBar.text = "cycling"
            controller.filterContentForSearchText("cycling", scope: "Default")
        }else if indexPath.section == 3{
            controller.tourCategory = "shopping"
            textFieldInsideSearchBar.text = "shopping"
            controller.filterContentForSearchText("shopping", scope: "Default")
        }else if indexPath.section == 4{
            controller.tourCategory = "realestate"
            textFieldInsideSearchBar.text = "realestate"
            controller.filterContentForSearchText("realestate", scope: "Default")
        }else if indexPath.section == 5{
            controller.tourCategory = "access"
            textFieldInsideSearchBar.text = "access"
            controller.filterContentForSearchText("access", scope: "Default")
        }else if indexPath.section == 6{
            controller.tourCategory = "more"
            textFieldInsideSearchBar.text = "more"
            controller.filterContentForSearchText("more", scope: "Default")
        
        }else if indexPath.section == 7{
            controller.tourCategory = "recommandation"
            textFieldInsideSearchBar.text = "recommandation"
            controller.filterContentForSearchText("recommandation", scope: "Default")
        }else {
            controller.tourCategory = "premium"
            textFieldInsideSearchBar.text = "premium"
            controller.filterContentForSearchText("premium", scope: "Default")

        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
