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
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTours()
        self.money.text = "0"
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDownload", for: indexPath)
        cell.textLabel?.text = "yes"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func payout(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Need payment details!", message: "The tour will be removed permanently", preferredStyle: .alert)
        let noAction: UIAlertAction = UIAlertAction(title: "Later", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let yesAction: UIAlertAction = UIAlertAction(title: "Provide now", style: .default) { action -> Void in
       //     let nv = self.storyboard!.instantiateViewController(withIdentifier: "PaymentDetailViewController") as!
            //PaymentDetailViewController
      //      self.present(nv, animated:true, completion:nil)
     //   }
        self.performSegue(withIdentifier: "paymentSegue", sender: self)
        }
        actionSheetController.addAction(yesAction)
        actionSheetController.addAction(noAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
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
