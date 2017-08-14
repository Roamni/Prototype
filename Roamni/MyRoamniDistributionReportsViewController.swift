//
//  MyRoamniDistributionReportsViewController.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
class MyRoamniDistributionReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var downLoadTimes: UILabel!
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var payout: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var money: UILabel!
    var downloadTours = [DownloadTour]()
    var total:Int = 0
    var userNumber = 0
    var hasPaymentDetial = false
    var downloads = [String : String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchTours()
        self.downloadTours.removeAll()
        fetchTours1()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = "(as of \(result))"
        print("lll\(self.downloadTours.count)")
        self.money.text = "$ 0.00"
        var ref:FIRDatabaseReference?
        let user = FIRAuth.auth()?.currentUser
        let uid = user!.uid
        ref = FIRDatabase.database().reference()
        ref?.child("paymentDetail").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            if result?.count == 0
            {
                
            }
            for child in result!{
                let dictionary = child.value as!  [String : Any]            // tour.setValuesForKeys(dictionary)
                print(dictionary)
                print("sssssss\(uid)")
                let uploadUser = dictionary["uploadUser"] as! String
                //tourType: dictionary["TourType"] as! String
                
                if uid == uploadUser{
                    self.hasPaymentDetial = true
                    print("bbbb\(self.hasPaymentDetial)")
                }
                
            } })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downloadTours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReportsPayoutViewCell", for: indexPath)
        as! MyRoamniReportsPayoutViewCell
    
            cell.nameField.text = self.downloadTours[indexPath.row].name
            //cell.moneyField.text = self.downloadTours[0]
        print("wwwwwwwww\(self.downloads[self.downloadTours[indexPath.row].name])")
        
        //        for index in 0...self.downloads.count-1 {
            //print("\(index) times 5 is \(index * 5)")
            //if self.downloads
       // }
        //self.downloads.
        //self.downloads[1].keys.
        cell.downloadsField.text = self.downloads[self.downloadTours[indexPath.row].name]
        cell.moneyField.text = "0.00"
        //}
        //self.downloadTours
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func payout(_ sender: Any) {
        
        print(self.hasPaymentDetial)
        if self.hasPaymentDetial == false{
            let actionSheetController: UIAlertController = UIAlertController(title: "Need payment details!", message: "The tour will be removed permanently", preferredStyle: .alert)
            let noAction: UIAlertAction = UIAlertAction(title: "Later", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            }
            let yesAction: UIAlertAction = UIAlertAction(title: "Provide now", style: .default) { action -> Void in
                self.performSegue(withIdentifier: "paymentSegue", sender: self)
            }
            actionSheetController.addAction(yesAction)
            actionSheetController.addAction(noAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }else{
            let actionSheetController: UIAlertController = UIAlertController(title: "Congratulation!", message: "You have earned $0.00. To be paid in 60 days", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            
            }
            actionSheetController.addAction(okAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    


    
    @IBAction func viewReports(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        
        ref?.child("tours").observe(.childAdded, with:{ (snapshot) in
            
            let dictionary = snapshot.value as!  [String : Any]
        
            //let longitude = (location["lon"] as! NSString).doubleValue
            if let user = FIRAuth.auth()?.currentUser{
                let uid = user.uid
                if uid == dictionary["uploadUser"] as! String
                {
                    let  counts:Int = Int(snapshot.childSnapshot(forPath: "user").childrenCount) - 1
                    
                    print(counts)
                    self.total += counts
                    //self.downLoadTimes.text = String(self.total)
                }
                
            }

        })
        
        
    }

    func fetchTours1(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                var numberofusers = 0
                let dictionary = child.value as!  [String : Any]
                // tour.setValuesForKeys(dictionary)
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
                
                
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:child.key, price: Float(dictionary["price"] as! Float))
                
                
                //self.artworks.removeAll()
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
                        //let tourdownload = [downloadTour.name : "\(numberofusers)"]
                        //let thenumber  = "\(numberofusers)"
                        self.downloads.update(other: [downloadTour.name : "\(numberofusers)"])
                        //([downloadTour.name : "\(numberofusers)"])
                        print("wwwwwwwww\(self.downloads)")
                        self.downLoadTimes.text = "\(self.userNumber)"
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
extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
