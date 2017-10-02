//
//  MyRoamniMyProfileViewController.swift
//  Roamni
//
//  Created by Hyman Li on 28/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import AVFoundation
import FirebaseAuth
import FBSDKLoginKit
import CoreLocation
class MyRoamniMyProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{


    
    @IBOutlet weak var setImage: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var aboutme: UITextView!
    @IBOutlet weak var uploadTourNumber: UILabel!
    
    @IBOutlet weak var countryPicker: UIPickerView!
    var lgoedUser : User?
    var lgoedUsers = [User]()
    
    var imagePicker = UIImagePickerController()
    var countryname : String!
    var downloadTours = [DownloadTour]()
    var payoutTours = [PayoutTour]()
    var total:Int = 0
    var userNumber = 0
    var hasPaymentDetial = false
    var downloads = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        aboutme.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        aboutme.layer.borderWidth = 1.0
        fetchTours1()
        fetchUser()
        //self.hideKeyboardWhenTappedAround() 
        //self.tableView.rowHeight = 40.0
        // Do any additional setup after loading the view.
    }

    
    @IBAction func setImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated:true){
            
        }
    }
    
    
    var countries: [String] = []
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryname = countries[row]
        print( self.countryname)
    }
    
    @IBAction func done(_ sender: Any) {
        print("done")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changePhoto(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userImage.image = image
        }else{
            print("error image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        userImage.image = image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.downloadTours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniMyProfileTableViewCell", for: indexPath)
            as! MyRoamniMyProfileTableViewCell
        //cell.frame.height = 40
        cell.tourName.text = self.downloadTours[indexPath.row].name
        cell.rating.rating = self.downloadTours[indexPath.row].star
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("high40")
        return 40.0;//Choose your custom row height
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
                                self.userNumber = self.userNumber + 1
                                numberofusers = numberofusers + 1
                                print("hhhhh\(self.userNumber)")
                            }
                        }
                        self.downloads.update(other: [downloadTour.name : "\(numberofusers - 1)"])
                        //self.countDownloads.update(other: [downloadTour.name : numberofusers - 1])
                        //self.totalDownloads.text = "\(self.userNumber - self.downloadTours.count)"
                        print("yyy\(downloadTour.name ) and \(numberofusers)")
                        DispatchQueue.main.async(execute: {
                            self.tableview.reloadData()
                            self.uploadTourNumber.text = "\(self.downloadTours.count)"
                            
                        } )
                        
                    }
                    
                }
                else{
                    print("no permission")
                }
            }
            
        })
        
    }
    
    func fetchUser(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("users").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
                let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                
                //print("aaaaaa\(dictionary["uploadUser"])")
                if let user = FIRAuth.auth()?.currentUser{
                    
                    let uemail = user.email
                    if  downloaduser.email == uemail
                    {
                        
                        self.lgoedUser = downloaduser
                        self.userName.text = "\(self.lgoedUser!.firstname) \(self.lgoedUser!.lastname)"
                        self.aboutme.text = self.lgoedUser?.aboutme
                        //self.downloadPayments.append(downloadTour)
                        //print(self.downloadTours)
                        DispatchQueue.main.async(execute: { } )
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

