//
//  NearByCollectionViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 7/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import ReachabilitySwift

private let reuseIdentifier = "Cell"

class NearByCollectionViewController: UICollectionViewController,CLLocationManagerDelegate {
    let reachability = Reachability()!

    var tours = [DownloadTour]()
    var tourInFive = [DownloadTour]()
    var controller : SearchContainerViewController!
    var locationManager = CLLocationManager()
    let categories =  [
        ["name":"Walking","pic":"walk"],
        ["name":"Driving","pic":"drive"],
        ["name":"Cycling","pic":"cycling"],
        ["name":"Shopping","pic":"shooping"],
        ["name":"Real Estate","pic":"realestate"],
        ["name":"Accessible","pic":"accessible"]
        //["name":"More","pic":"moretour"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
            //self.fetchTours()
        
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

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
                
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "Pleasant", uploadUser: dictionary["uploadUser"] as! String,tourId: child.key)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as UICollectionViewCell
        (cell.contentView.viewWithTag(1) as! UIImageView).image = UIImage(named:categories[indexPath.item]["pic"]!)
     //   (cell.contentView.viewWithTag(2) as! UILabel).text =
       //     categories[indexPath.item]["name"]
    
        // Configure the cell
        
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap -- \(indexPath.row)")
        let textFieldInsideSearchBar = controller.searchController.searchBar.value(forKey: "searchField") as! UITextField
        tabBarController?.selectedIndex = 1
        controller.navigationController?.popViewController(animated: true)
        controller.tourCategory = categories[indexPath.item]["name"]
        textFieldInsideSearchBar.text = categories[indexPath.item]["name"]
        controller.filterContentForSearchText(categories[indexPath.item]["name"]!, scope: "Default")
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
