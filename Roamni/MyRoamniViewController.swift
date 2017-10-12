//
//  MyRoamniViewController.swift
//  Roamni
//
//  Created by zihaowang on 5/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class MyRoamniViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    let loginButton = FBSDKLoginButton()
    var logedUser : User?
    var userid : String?
    
    override func viewWillAppear(_ animated: Bool) {
         self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.tableFooterView = UIView()
        //DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
        self.tableView.reloadData()
        
        //})
        
        
    }
    
//    func removeDuplicateUser(){
//        var ref:FIRDatabaseReference?
//        ref = FIRDatabase.database().reference()
//        ref?.child("users").observeSingleEvent(of:.value, with:{ (snapshot) in
//            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
//            for child in result!{
//
//                let dictionary = child.value as!  [String : Any]
//                let lastname = dictionary["lastname"] as? String
//                print("testestest\(lastname)")
//                if lastname == nil{
//
//
//                    ref?.child("users/\(child.key)").removeValue()
//                }
//
//            }
//        })
//
//
//    }
    
//    func fetchUser(){
//        var ref:FIRDatabaseReference?
//        ref = FIRDatabase.database().reference()
//        ref?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
//            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
//            for child in result!{
//                let dictionary = child.value as!  [String : Any]
//                let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
//                if let user = FIRAuth.auth()?.currentUser{
//                    let uemail = user.email
//                    if  downloaduser.email == uemail
//                    {
//                        self.logedUser = downloaduser
//                        print("\(self.logedUser!.firstname)  andand \(self.logedUser!.lastname)")
//
//                        print("\(self.logedUser!.userimage) andand \(self.logedUser!.firstname) \(self.logedUser!.email)")
//                        self.userid = child.key
//                        //self.downloadPayments.append(downloadTour)
//                        //print(self.downloadTours)
//                        DispatchQueue.main.async(execute: { } )
//                    }
//                }
//                else{
//                    print("1111111111111144")
//                    print("no permission")
//                }
//            }
//        })
//
//    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        //let photo = user.photoURL
        
    }
    
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
//        case 7: return 1
//        case 8: return 1
        default: return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        // #warning Incomplete implementation, return the number of sections
        return 10
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.0000001
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 0{
            return 80.0//Choose your custom row height
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

        
        return 100.0
    }
    
    //This function returns a cell for a table view, the returned object is of
    //type UITableViewCell. These are the objects that users see in the table's rows.
    //This function basically returns a cell, for a table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //Return the cell with identifier NotificationTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniUserCell", for: indexPath as IndexPath) as! MyRoamniUserCell
            cell.loginBn.readPermissions =  ["public_profile","email"]
            cell.loginBn.delegate = self
//            if FIRAuth.auth()?.currentUser != nil {
//                cell.loginBn.isHidden = true
//            }
            if let user = FIRAuth.auth()?.currentUser{
                //user.
                let email = user.email
                let uid = user.uid
                let name = user.displayName
                let photo = user.photoURL
                cell.userPhoto.loadImageUsingCacheWithUrlString(urlString: "\(user.photoURL!)")
                let ref = FIRDatabase.database().reference()
                ref.child("users/\(uid)/email").setValue(email)
                if user.photoURL != nil{
                    if photo != nil{
                     cell.userPhoto.loadImageUsingCacheWithUrlString(urlString: "\(photo!)")
                        print("jijijijiji11111")
                        print("\(photo!)")
                     //cell.loginBn.isHidden = false
                    cell.logoutBn.isHidden = true
                        
                    }

                }else{
                    cell.loginBn.isHidden = true
                }
                var ref1:FIRDatabaseReference?
                ref1 = FIRDatabase.database().reference()
                ref1?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
                    let result = snapshot.children.allObjects as? [FIRDataSnapshot]
                    for child in result!{
                        let dictionary = child.value as!  [String : Any]
                        let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                        if let user = FIRAuth.auth()?.currentUser{
                            let uemail = user.email
                            if  downloaduser.email == uemail
                            {
                                self.logedUser = downloaduser
                                self.userid = child.key
                                if self.logedUser!.userimage != "image"{
                                cell.userPhoto.loadImageUsingCacheWithUrlString(urlString: "\(self.logedUser!.userimage)")
                                    print("jijijijiji2222")
                                }else{
                                 cell.userPhoto.image = UIImage(named: "Roamni")
                                    print("jijijijiji3333")
                                }
                                cell.userLabel.text = "\(self.logedUser!.firstname) \(self.logedUser!.lastname)"
                                //self.downloadPayments.append(downloadTour)
                                //print(self.downloadTours)
                                DispatchQueue.main.async(execute: { } )
                            }
                        }
                        else{
                            print("1111111111111144")
                            print("no permission")
                        }
                    }
                })
                
                cell.userLabel.text = name
            }else
                {
                    cell.userPhoto.image = UIImage(named: "Roamni")
                    print("jijijijiji4444")
                    cell.userLabel.text = "Please log in"
                
            }
            return cell
        }else if indexPath.section == 1{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniEidtProfileCell", for: indexPath as IndexPath)
                as! MyRoamniEidtProfileCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else if indexPath.section == 2{
            //Return the cell with identifier BackTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniRequestTourCell", for: indexPath as IndexPath) as! MyRoamniRequestTourCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else if indexPath.section == 3{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniUploadTourCell", for: indexPath as IndexPath)
                as! MyRoamniUploadTourCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
            
            
        }else if indexPath.section == 4{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniDistributionCell", for: indexPath as IndexPath)
                as! MyRoamniDistributionCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
            
        }else if indexPath.section == 5{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniGiveFeedbackCell", for: indexPath as IndexPath)
                as! MyRoamniGiveFeedbackCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else if indexPath.section == 6{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniHowCell", for: indexPath as IndexPath)
                as! MyRoamniHowCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
            
        }else if indexPath.section == 7{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniAboutCell", for: indexPath as IndexPath)
                as! MyRoamniAboutCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniSettingCell", for: indexPath as IndexPath)
                as! MyRoamniSettingCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if indexPath.section == 3{
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let modalVC = storyboard.instantiateViewController(withIdentifier: "uploadView") as? MyRoamniUploadToursViewController
//                    self.present(modalVC!, animated: true, completion: nil)
                self.alertBn(title: "Upload", message: "Please open the Voice Memo => choose a record => share => Roamni")
        
            }
        
            if indexPath.section == 4{
                if let user = FIRAuth.auth()?.currentUser{
                    performSegue(withIdentifier: "reportSegue", sender: self)
                }
                else{
                    self.alertBn(title: "Reminder", message: "Please Log In to access your reports & payout.")
                }
        }
        
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch(section) {
        case 0:return "  "
        case 1:return "  "    
        default :return ""
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
extension MyRoamniViewController:FBSDKLoginButtonDelegate{

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try!FIRAuth.auth()?.signOut()
        print("log out of facebook")
        self.tableView.reloadData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MyRoamniLogViewController = storyboard.instantiateViewController(withIdentifier: "MyRoamniLogViewController") as! MyRoamniLogViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        else if result.isCancelled {
            // Handle cancellations
            return
        }else{
         let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                print(error)
                return
            }
            self.tableView.reloadData()
        }
        print("successfully logged in ")
        }
    }
    
}
