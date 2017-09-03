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
    var payoutTours = [PayoutTour]()
    var total:Int = 0
    var userNumber = 0
    var hasPaymentDetial = false
    var downloads = [String : String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.downloadTours.removeAll()
        self.payoutTours.removeAll()
        //self.downloadTours.removeAll()
        //self.payoutTours.removeAll()
        fetchTours()
        fetchTours1()
        fetchTours2()
        //self.tableview.reloadData()
        //let date = Date()
        //let formatter = DateFormatter()
       // formatter.dateFormat = "dd.MM.yyyy"
        //let result = formatter.string(from: date)

        
        print("lll\(self.downloadTours.count)")
        //self.money.text = "$ 0.00"
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
                let dictionary = child.value as!  [String : Any]
                let uploadUser = dictionary["uploadUser"] as! String
                if uid == uploadUser{
                    self.hasPaymentDetial = true
                    print("bbbb\(self.hasPaymentDetial)")
                }
                
            } })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //self.money.text = "$\(totalEarn)"
        
        
        return self.downloadTours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReportsPayoutViewCell", for: indexPath)
        as! MyRoamniReportsPayoutViewCell
        cell.nameField.text = self.downloadTours[indexPath.row].name
        
        //cell.downloadsField.text = self.downloads[self.downloadTours[indexPath.row].name]
        let a:Int = Int(self.downloads[self.downloadTours[indexPath.row].name]!)!
        var b : Int = 0
        if indexPath.row < self.payoutTours.count{
            b = self.payoutTours[indexPath.row].downloads
        }else{
            b = 0
        }
        cell.downloadsField.text = "\(a - b)"
        
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: self.downloads[self.downloadTours[indexPath.row].name]!)
        let numberFloatValue = number!.floatValue
        var calMoney = Double(self.downloadTours[indexPath.row].price * numberFloatValue * 0.35).rounded(toPlaces: 2)//Float(self.downloadTours[indexPath.row].price * numberFloatValue * 0.35)
        //calMoney = Float(round(1000 * calMoney)/1000)
        print("dodododododododo \(calMoney)")
        var payoutMoney = Double(0)
        if indexPath.row < self.payoutTours.count{
            payoutMoney = Double(self.payoutTours[indexPath.row].money).rounded(toPlaces: 2)
        }else{
            //let payoutMoney = Double(0)
            payoutMoney = Double(0)
        }
        print("dodododododododohhh \(payoutMoney)")
        calMoney = calMoney - payoutMoney
        Double(calMoney).rounded(toPlaces: 2)
        print("dodododododododohhhjjj \(cleanDollars("\(calMoney)"))")
        cell.moneyField.text = cleanDollars("\(calMoney)")//"$\(calMoney)"
        
        return cell
    }
    
    func cleanDollars(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
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
            if self.money.text! != "$0.00"{
                let actionSheetController: UIAlertController = UIAlertController(title: "Congratulation!", message: "You have earned $\(self.money.text!). To be paid in 60 days", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            
                }
                actionSheetController.addAction(okAction)
                self.present(actionSheetController, animated: true, completion: nil)
                var ref:FIRDatabaseReference?
                ref = FIRDatabase.database().reference()
                let user = FIRAuth.auth()?.currentUser
                let uid = user?.uid
                ref?.child("payoutRecord").childByAutoId().setValue(["date":self.dateLabel.text,"money":self.money.text,"uploadUser":uid])
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let result = formatter.string(from: date)
                let numberFormatter = NumberFormatter()
            
                for tour in self.downloadTours{
                    let number = numberFormatter.number(from: self.downloads[tour.name]!)
                    let numberFloatValue = number!.floatValue
                    let money = tour.price * numberFloatValue * 0.35
                    let nameRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("PreviousTotalPayout/\(tour.tourId)/name")
                    nameRef.setValue(tour.name)
                    let downloadsRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("PreviousTotalPayout/\(tour.tourId)/downloads")
                    downloadsRef.setValue(Int(number!))
                    let moneyRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("PreviousTotalPayout/\(tour.tourId)/money")
                    moneyRef.setValue(money)
                    let uploaderRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("PreviousTotalPayout/\(tour.tourId)/uploadUser")
                    uploaderRef.setValue(uid)
                    let dateRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("PreviousTotalPayout/\(tour.tourId)/date")
                    dateRef.setValue(result)
                }
                self.money.text = "$0.00"
                
                self.tableview.reloadData()
                
            }else{
                let actionSheetController: UIAlertController = UIAlertController(title: "Sorry!", message: "You have not earned money yet", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                    
                }
                actionSheetController.addAction(okAction)
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
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
                        self.downloads.update(other: [downloadTour.name : "\(numberofusers - 1)"])
                        //([downloadTour.name : "\(numberofusers)"])
                        print("wwwwwwwww\(self.downloads)")
                        //self.downLoadTimes.text = "\(self.userNumber)"
                        print("yyy\(downloadTour.name ) and \(numberofusers - 1)")
                        DispatchQueue.main.async(execute: {self.tableview.reloadData() } )
                        
                    }
                    
                }
                else{
                    print("no permission")
                }
            }
        })
        
        
    }
    
    
    func fetchTours2(){
        print("有")
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("PreviousTotalPayout").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
            let dictionary = child.value as!  [String : Any]
            let downloadTour = PayoutTour(name: dictionary["name"] as! String, uploadUser: dictionary["uploadUser"] as! String,tourId:child.key, date: dictionary["date"] as! String, money: Float(dictionary["money"] as! Float), downloads: dictionary["downloads"] as! Int)
                if let user = FIRAuth.auth()?.currentUser{
                    print("没有")
                    let uid = user.uid
                    if downloadTour.uploadUser == uid
                    {
                        self.payoutTours.append(downloadTour)
                        print("没有！")
                        //print("payoutpayoutpayout\(self.payoutTours)")
                        DispatchQueue.main.async(execute: {
                            print("有没有！")
                            if self.payoutTours.count != 0{
                                self.dateLabel.text = "(as of \(self.payoutTours[0].date))"
                            }else{
                                self.dateLabel.text = "(You have not requested payout before)"
                            }
                            var totalEarn : Double = 0.0
                            for nnn in 0..<self.downloadTours.count{
                                var payoutMoney = Double(0)
                                if nnn < self.payoutTours.count{
                                    payoutMoney = Double(self.payoutTours[nnn].money).rounded(toPlaces: 2)
                                }else{
                                    payoutMoney = Double(0)
                                }
                                
                                let numberFormatter = NumberFormatter()
                                let number = numberFormatter.number(from: self.downloads[self.downloadTours[nnn].name]!)
                                let numberFloatValue = number!.floatValue
                                var calMoney = Double(self.downloadTours[nnn].price * numberFloatValue * 0.35).rounded(toPlaces: 2)
                                calMoney = calMoney - payoutMoney
                                totalEarn =  totalEarn + calMoney
                                
                            }
                            
                            self.money.text = self.cleanDollars("\(totalEarn)")
                            self.tableview.reloadData()
                        } )
                    }
                    
                }
                else{
                    print("no permission")
                }
            }
            print("有没有！")
            if self.payoutTours.count != 0{
                self.dateLabel.text = "(as of \(self.payoutTours[0].date))"
            }else{
                self.dateLabel.text = "(You have not requested payout before)"
            }
            var totalEarn : Double = 0.0
            for nnn in 0..<self.downloadTours.count{
                var payoutMoney = Double(0)
                if nnn < self.payoutTours.count{
                    payoutMoney = Double(self.payoutTours[nnn].money).rounded(toPlaces: 2)
                }else{
                    payoutMoney = Double(0)
                }
                
                let numberFormatter = NumberFormatter()
                let number = numberFormatter.number(from: self.downloads[self.downloadTours[nnn].name]!)
                let numberFloatValue = number!.floatValue
                var calMoney = Double(self.downloadTours[nnn].price * numberFloatValue * 0.35).rounded(toPlaces: 2)
                calMoney = calMoney - payoutMoney
                totalEarn =  totalEarn + calMoney
                
            }
            
            self.money.text = self.cleanDollars("\(totalEarn)")
            self.tableview.reloadData()

            
        })
        
        
    }


}
extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
