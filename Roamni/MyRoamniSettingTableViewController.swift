//
//  MyRoamniSettingTableViewController.swift
//  Roamni
//
//  Created by Hyman Li on 26/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import AVFoundation
import FirebaseAuth
import FBSDKLoginKit
class MyRoamniSettingTableViewController: UITableViewController {

    var logedUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //fetchUser()
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

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 // your number of cell here
        switch(section)
        {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        //        case 8: return 1
        default: return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch(section) {
        case 0:return "  "
        case 1:return "  "
        default :return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
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
        return 100.0
    }
    
    //This function returns a cell for a table view, the returned object is of
    //type UITableViewCell. These are the objects that users see in the table's rows.
    //This function basically returns a cell, for a table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniSettingNameTableViewCell", for: indexPath as IndexPath)
                as! MyRoamniSettingNameTableViewCell
            if let user = FIRAuth.auth()?.currentUser{
                let email = user.email
                let uid = user.uid
                let name = user.displayName
                let photo = user.photoURL
                let ref = FIRDatabase.database().reference()
                ref.child("users/\(uid)/email").setValue(email)
                if user.photoURL != nil{
                    if photo != nil{
                        
                        cell.imageView!.loadImageUsingCacheWithUrlString(urlString: "\(photo!)")
                        cell.name.text = user.displayName
                    }
                    
                }else{
                    var ref:FIRDatabaseReference?
                    ref = FIRDatabase.database().reference()
                    ref?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
                        let result = snapshot.children.allObjects as? [FIRDataSnapshot]
                        for child in result!{
                            let dictionary = child.value as!  [String : Any]
                            let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                            if let user = FIRAuth.auth()?.currentUser{
                                let uemail = user.email
                                if  downloaduser.email == uemail
                                {
                                    self.logedUser = downloaduser
                                   
                                    //if self.logedUser!.userimage != "image"{
                                       cell.imageView!.loadImageUsingCacheWithUrlString(urlString: "\(self.logedUser!.userimage)")
                                    //}

                                    cell.name.text = "\(self.logedUser!.firstname) \(self.logedUser!.lastname)"
                                    DispatchQueue.main.async(execute: { } )
                                }
                            }
                            else{
                                print("1111111111111144")
                                print("no permission")
                            }
                        }
                    })
                    
                }
            }
            
            return cell
        }else if indexPath.section == 1{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniSettingPaymentTableViewCell", for: indexPath as IndexPath)
                as! MyRoamniSettingPaymentTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else if indexPath.section == 2{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniSettingTermsTableViewCell", for: indexPath as IndexPath)
                as! MyRoamniSettingTermsTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else{
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniSettingVersionTableViewCell", for: indexPath as IndexPath)
                as! MyRoamniSettingVersionTableViewCell
            //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
    
    }
    

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
