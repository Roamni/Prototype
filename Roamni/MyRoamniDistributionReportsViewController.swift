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
   
    @IBOutlet weak var payout: UIButton!

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var money: UILabel!
    var total:Int = 0
    var hasPaymentDetial = false
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTours()
        self.money.text = "0"
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

        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReportsPayoutViewCell", for: indexPath)
        as! MyRoamniReportsPayoutViewCell
        //cell.textLabel?.text = "yes"
        if indexPath.row == 0{
            cell.nameField.text = "Tour Name"
            cell.moneyField.text = "$"
            cell.downloadsField.text = "Downloads"
        }
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
                    self.downLoadTimes.text = String(self.total)
                }
                
            }
            
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
            //self.artworks.removeAll()
           
            
            
            
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
