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
import MessageUI
class MyRoamniReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FloatRatingViewDelegate, MFMailComposeViewControllerDelegate {
    /**
     Returns the rating value when touch events end
     */
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //self.rating = Int(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }


    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var totalEarn: UILabel!
    @IBOutlet weak var totalDownloads: UILabel!
    
    @IBOutlet weak var mostPopularTour: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var downloadTours = [DownloadTour]()
    var downloads = [String : String]()
    var countDownloads = [String : Int]()
    var userNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTours1()
        
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        //Set star rating
        self.floatRatingView.editable = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Task: NSObject {
        var date: String = ""
        var name: String = ""
        var startTime: String = ""
        var endTime: String = ""
    }
   
    var taskArr = [Task]()
    var task: Task!

    //example data
    //let filename = "testfile"
    let fileName = "sample.csv"
    
    
    @IBAction func exportCSV(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
       // for tour in self.downloadTours{
            
        //}
        //cell.nameField.text = self.downloadTours[indexPath.row].name
        //cell.downloadsField.text = self.downloads[self.downloadTours[indexPath.row].name]
        //var strings = ["a","b"]
        var mailString = NSMutableString()
        mailString.append("Tour Name, Total Downloads, Total $\n")
        for index in 0..<self.downloadTours.count{
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: self.downloads[self.downloadTours[index].name]!)
            let numberFloatValue = number!.floatValue
            let money = Double(self.downloadTours[index].price * numberFloatValue * 0.35).rounded(toPlaces: 2)
            mailString.append("\(self.downloadTours[index].name), \(self.downloads[self.downloadTours[index].name]!), \(cleanDollars("\(money)"))\n")
        }
        
        //let joinedString = strings.joined(separator: "\n")
        //print(joinedString)
        mailComposerVC.setToRecipients(["info@roamni.com"])
        mailComposerVC.setSubject("Sending you a Roamni report")
        mailComposerVC.setMessageBody("The CSV file reports your Roamni statistics!", isHTML: false)
        if let data = (mailString as NSString).data(using: String.Encoding.utf8.rawValue){
            //Attach File
            mailComposerVC.addAttachmentData(data, mimeType: "text/csv", fileName: "sample.csv")
            //self.presentViewController(mailComposer, animated: true, completion: nil)
        }
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again, Please open Setting => iTunes => Turn on Mail", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: CSV file creating
    func creatCSV() -> Void {
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Task Name,Time Started,Time Ended\n"
        
        for task in taskArr {
            let newLine = "\(task.date),\(task.name),\(task.startTime),\(task.endTime)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
    }



    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["paul@hackingwithswift.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("gogogogogo")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result{
        case .sent:
            print("邮件已发送")
        case .cancelled:
            print("邮件已取消")
        case .saved:
            print("邮件已保存")
        case .failed:
            print("邮件发送失败")
        }
    }
  
 
    
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalEarn : Double = 0.0
        print("aaaaaaa\(self.downloadTours.count)")
        for tour in self.downloadTours{
            let downloadNumber = self.downloads[tour.name]
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: downloadNumber!)
            let numberFloatValue = number!.floatValue
            let money = Double(tour.price * numberFloatValue * 0.35).rounded(toPlaces: 2)//tour.price * numberFloatValue * 0.35
            totalEarn = totalEarn + money
        }
        let money = Double(totalEarn).rounded(toPlaces: 2)
        self.totalEarn.text = cleanDollars("\(totalEarn)")//"$\(totalEarn)"
        //self.downloads.values.
        //self.downloadTours.sorted({ $0. > $1.fileID })

        let fruitsTupleArray = self.countDownloads.sorted{ $0.value > $1.value }
        self.mostPopularTour.text = fruitsTupleArray.first?.key

        return self.downloadTours.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReportsViewCell", for: indexPath)
            as! MyRoamniReportsViewCell
        cell.nameField.text = self.downloadTours[indexPath.row].name
        cell.downloadsField.text = self.downloads[self.downloadTours[indexPath.row].name]
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: cell.downloadsField.text!)
        let numberFloatValue = number!.floatValue
        let money = Double(self.downloadTours[indexPath.row].price * numberFloatValue * 0.35).rounded(toPlaces: 2)//self.downloadTours[indexPath.row].price * numberFloatValue * 0.35
        cell.moneyField.text = cleanDollars("\(money)")//"$\(money)"
        
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
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, mode: dictionary["mode"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String, uploadUserEmail: dictionary["uploaderemail"] as! String,tourId:child.key, price: Float(dictionary["price"] as! Float))
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
                                self.userNumber = self.userNumber + 1
                                numberofusers = numberofusers + 1 
                                print("hhhhh\(self.userNumber)")
                            }
                        }
                        self.downloads.update(other: [downloadTour.name : "\(numberofusers - 1)"])
                        self.countDownloads.update(other: [downloadTour.name : numberofusers - 1])
                        self.totalDownloads.text = "\(self.userNumber - self.downloadTours.count)"
                        print("yyy\(downloadTour.name ) and \(numberofusers)")
                        DispatchQueue.main.async(execute: {
                            var averageRate : Float = 0.0
                            for tour in self.downloadTours{
                                averageRate = averageRate + tour.star
                            }
                            averageRate = averageRate/Float(self.downloadTours.count)
                            
                            self.floatRatingView.rating = averageRate
                            print("rateraterate\(averageRate)")
                            self.tableview.reloadData() } )
                        
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
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sorted(by: isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}
