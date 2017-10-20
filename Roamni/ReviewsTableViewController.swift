//
//  ReviewsTableViewController.swift
//  Roamni
//
//  Created by Hyman Li on 12/10/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase

class ReviewsTableViewController: UITableViewController, FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //
    }
    
    
    var tourID : String!
    var reviews  = [Review]()

    @IBAction func back(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addComment(_ sender: Any) {
        performSegue(withIdentifier: "addComment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"
        {
            let controller:AddReviewViewController = segue.destination as! AddReviewViewController
            
            controller.tourID = self.tourID
            
        }else  if segue.identifier == "goToReviewDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! ReviewDetailViewController
                
                //controller.currentIndex = indexPath.row
                controller.review = self.reviews[indexPath.row]
                //controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
        return self.reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniReviewTableViewCell", for: indexPath) as! MyRoamniReviewTableViewCell
        cell.reviewLabel.text = self.reviews[indexPath.row].comment

        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("usersinfor").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
//                let downloaduser = User(email: dictionary["email"] as! String, firstname: dictionary["firstname"] as! String, lastname: dictionary["lastname"] as! String, aboutme: dictionary["aboutme"] as! String, country: dictionary["country"] as! String, userimage: dictionary["image"] as! String)
                let email = dictionary["email"] as! String

                if email == self.reviews[indexPath.row].useremail{
                    cell.userName.text = "\(dictionary["firstname"]!) \(dictionary["lastname"]!)"
                }
            }
        })
        
        cell.reviewRating.emptyImage = UIImage(named: "StarEmpty")
        cell.reviewRating.fullImage = UIImage(named: "StarFull")
        // Optional params
        cell.reviewRating.delegate = self
        cell.reviewRating.contentMode = UIViewContentMode.scaleAspectFit
        cell.reviewRating.maxRating = 5
        cell.reviewRating.minRating = 1
        //Set star rating
        cell.reviewRating.rating = 3
        cell.reviewRating.editable = false
        cell.reviewRating.rating = self.reviews[indexPath.row].star
        return cell
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
