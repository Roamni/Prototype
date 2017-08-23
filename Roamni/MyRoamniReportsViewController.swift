//
//  MyRoamniReportsViewController.swift
//  Roamni
//
//  Created by Hyman Li on 23/8/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
class MyRoamniReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalEarn: UILabel!
    @IBOutlet weak var totalDownloads: UILabel!
    
    @IBOutlet weak var mostPopularTour: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var downloadTours = [DownloadTour]()
    var downloads = [String : String]()
    var userNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTours1()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalEarn : Float = 0.0
        print("aaaaaaa\(self.downloadTours.count)")
        for tour in self.downloadTours{
            let downloadNumber = self.downloads[tour.name]
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: downloadNumber!)
            let numberFloatValue = number!.floatValue
            let money = tour.price * numberFloatValue * 0.35
            totalEarn = totalEarn + money
        }
        self.totalEarn.text = "$\(totalEarn)"

        return self.downloadTours.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReportsViewCell", for: indexPath)
            as! MyRoamniReportsViewCell
        cell.nameField.text = self.downloadTours[indexPath.row].name
        print("wwwwwwwww\(self.downloads[self.downloadTours[indexPath.row].name])")
        cell.downloadsField.text = self.downloads[self.downloadTours[indexPath.row].name]
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: cell.downloadsField.text!)
        let numberFloatValue = number!.floatValue
        let money = self.downloadTours[indexPath.row].price * numberFloatValue * 0.35
        cell.moneyField.text = "$\(money)"
        
        return cell
    }
    
    func fetchTours1(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                var numberofusers = 0
                let dictionary = child.value as!  [String : Any]
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
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:child.key, price: Float(dictionary["price"] as! Float))
                if let user = FIRAuth.auth()?.currentUser{
                    let uid = user.uid
                    if downloadTour.uploadUser == uid
                    {
                        self.downloadTours.append(downloadTour)
                        print(self.downloadTours)
                        let users = dictionary["user"] as!  [String : String]
                        //self.downloads.
                        for user in users{
                            if user.value == "buy"{
                                //print("buy")
                                self.userNumber = self.userNumber + 1
                                numberofusers = numberofusers + 1
                                print("hhhhh\(self.userNumber)")
                            }
                        }
                        self.downloads.update(other: [downloadTour.name : "\(numberofusers)"])
                        //([downloadTour.name : "\(numberofusers)"])
                        print("wwwwwwwww\(self.downloads)")
                        self.totalDownloads.text = "\(self.userNumber)"
                        print("yyy\(downloadTour.name ) and \(numberofusers)")
                        DispatchQueue.main.async(execute: {self.tableview.reloadData() } )
                        
                    }
                    
                }
                else{
                    print("no permission")
                }
            }
            
        })
        
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
