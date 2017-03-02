//
//  MyRoamniIncomingRequestTableViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 2/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
class MyRoamniIncomingRequestTableViewController: UITableViewController {

    var downloadTours = [Tour]()
    var downloadTour:Tour?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchTours()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return downloadTours.count
    }

    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        
        ref?.child("requestTours").observe(.childAdded, with:{ (snapshot) in
            
            let dictionary = snapshot.value as!  [String : Any]
            // tour.setValuesForKeys(dictionary)
            let startLocation = dictionary["startPoint"] as!  [String : Any]
            
            let latitude1 = String(describing: startLocation["lat"]!)
            
            let latitude = Double(latitude1)
            
            let longitude1 = String(describing: startLocation["lon"]!)
            
            let longitude = Double(longitude1)
            //let longitude = (location["lon"] as! NSString).doubleValue
            let startCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            
            let downloadTour = Tour(attraction: dictionary["Attraction"] as! String, locations: startCoordinate, desc:dictionary["desc"] as! String,tourType: dictionary["TourType"] as! String)
            
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
            //self.artworks.removeAll()
                    self.downloadTours.append(downloadTour)
                    DispatchQueue.main.async(execute: {self.tableView.reloadData() } )
                    
            
            
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showcell", for: indexPath)
        let atour:Tour = downloadTours[indexPath.row]
      cell.textLabel?.text = atour.attraction
        // Configure the cell...
       
        return cell
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRequestDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let tour:Tour = self.downloadTours[indexPath.row]
                
                let controller = segue.destination as! MyRoamniIncomingRequestDetail
                controller.detailTour = tour
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
