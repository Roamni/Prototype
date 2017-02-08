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
class NearbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate{

    

    
    @IBOutlet weak var tableView: UITableView!
    var place : TourForMap?
    var tours = [Tour]()
    var tourInFive = [Tour]()
    var controller : SearchContainerViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        // self.tableView.dataSource = self
        // self.tableView.delegate = self
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
//            self.tableView.reloadData()
//             //self.fetchTours()
//        })
        
        
    }
    
    override func viewDidLoad() {
         navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        tours = [
            Tour(songid:1, category:"walking", name:"Melbourne Central",locations:CLLocationCoordinate2D(latitude: -37.8426083, longitude: 144.9685646), desc: "This is the largest shopping centre, office and public transport hub in the city of Melbourne.", address:"211 La Trobe St, Melbourne", star:"1",length:"1",difficulty:"Pleasant"),
            Tour(songid:2,category:"walking", name:"Victoria Gallery",locations:CLLocationCoordinate2D(latitude: -35.8426083, longitude: 142.9685646), desc: "The public national gallery, popularly known as NGV, is an art museum in Melbourne.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Pleasant"),
            Tour(songid:3,category:"driving", name:"The Great Ocean Road",locations:CLLocationCoordinate2D(latitude: -38.6805638, longitude: 143.3894295), desc: "The Great Ocean Road is an Austrilian national heritage, a road along with the south-eastern coast of Austrilian.", address:"Great Ocean Rd, Victoria",star:"1",length:"1",difficulty:"Brisk"),
            Tour(songid:4,category:"cycling", name:"Yarra Valley",locations:CLLocationCoordinate2D(latitude: -37.6426083, longitude: 144.9665646), desc: "Yarra Valley is the most beautiful valley in victory, you can explore the chateaus and the famous chocolate factory.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Pleasant"),
            Tour(songid:5,category:"shopping", name:"DFO",locations:CLLocationCoordinate2D(latitude: -37.8426083, longitude: 143.9685646), desc: "With big brands and big savings of up to 70%, DFO (Direct Factory Outlets) is the best place for shopping for shoes, clothes, luggage and sunglasses.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Pleasant"),
            Tour(songid:6,category:"realestate", name:"South Yarra",locations:CLLocationCoordinate2D(latitude: -37.26083, longitude: 144.9685646), desc: "Explore the many restaurants, cafés, bars, shops and events in South Yarra with Time Out Melbourne's guide to this inner-city hub for shopping and fashion.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Workout"),
            Tour(songid:7,category:"access", name:"Federation Square",locations:CLLocationCoordinate2D(latitude: -37.846083, longitude: 144.965646), desc: "Federation Square is a mixed-use development in the inner city of Melbourne, covering an area of 3.2 ha (7.9 acres) and centred on three major public spaces.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Brisk"),
            Tour(songid:8,category:"more", name:"St Kilda Beach",locations:CLLocationCoordinate2D(latitude: -37.8426083, longitude: 140.965646), desc: "Summer isn't summer until you've spent a day by the seaside at St Kilda Beach, a short tram ride from the CBD. ", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Pleasant"),
            Tour(songid:9,category:"premium", name:"Eureka Tower Melbourne",locations:CLLocationCoordinate2D(latitude: -37.26083, longitude: 143.9685646), desc: "Eureka Skydeck 88 has awe inspiring views of Melbourne from the highest public vantage point in the Southern Hemisphere.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Workout"),
            Tour(songid:10,category:"recommandation", name:"Mornington",locations:CLLocationCoordinate2D(latitude: -37.821638, longitude: 144.9623461), desc: "Just an hour from Melbourne. Explore the galleries, spas and cafes in breezy seaside villages, cool off with a day on the beach, or escape to the hinterland for gourmet delights at boutique wineries.", address:"7 Riverside Quay, Southbank VIC",star:"1",length:"3",difficulty:"Pleasant")]


        
        controller = tabBarController?.viewControllers![1].childViewControllers[0] as! SearchContainerViewController
        //change here to apply 5 km
        controller.tours = tours
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
            
            let tour = Tour(songid:dictionary["id"] as! Int,category:dictionary["TourType"] as! String, name:dictionary["Name"] as! String,locations:coordinate, desc: dictionary["desc"] as! String, address: dictionary["desc"] as! String,star:"1",length:"1",difficulty:"Pleasant")
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            print(tour)
            print("tourn is \(tour.locations)")
            //self.tours.append(tour)
            
            self.place = TourForMap(title: tour.name, info: tour.name, coordinate: coordinate)
           // self.mapView.addAnnotation(place)
            
            //self.artworks.removeAll()
            //DispatchQueue.main.async(execute: {self.tableView.reloadData() } )
            
        })
        { (error) in
            print(error.localizedDescription)
        }
        tableView.tableFooterView = UIView()

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
