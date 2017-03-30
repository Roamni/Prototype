//
//  FilterTableViewController.swift
//  Roamni
//
//  Created by Hyman Li on 20/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController,ValueReturner {
    var returnValueToCaller: ((Any) -> ())?

    var Rateing:Int?
    var Length:Int?
    var Difficulty:Int?
    var Fcontroller:SearchContainerViewController?
    var tours = [DownloadTour]()
    var filterTours1 = [DownloadTour]()
    var filterTours2 = [DownloadTour]()
    var filterTours3 = [DownloadTour]()

    @IBAction func FilterDone(_ sender: Any) {
        filterTours1.removeAll()
        filterTours2.removeAll()
        filterTours3.removeAll()

        switch self.Rateing! {

        case 0 :
            
            for tour in tours
            {
                if Int(tour.star) <= 3
                {
                    self.filterTours1.append(tour)
                
                }
            
            }
            break
        case 1 :
            for tour in tours
            {
                if Int(tour.star) == 4
                {
                    self.filterTours1.append(tour)
                    
                }
              
            }
            break
        case 2 :
            for tour in tours
            {
                if Int(tour.star) == 5
                {
                    self.filterTours1.append(tour)
                    
                }
             
            }
            break
        default:
            for tour in tours
            {
                if Int(tour.star) <= 3
                {
                    self.filterTours1.append(tour)
                    
                }
                
            }
           break
        }
            switch self.Length! {
            case 0 :
            
                for tour in filterTours1
                {
                    if tour.length <= 1
                    {
                        
                        self.filterTours2.append(tour)
                        
                    }
                    
                }
                break
            case 1 :
                for tour in filterTours1
                {
                    if Int(tour.length)!>1 && Int(tour.length)!<=2
                    {
                        self.filterTours2.append(tour)
                        
                    }
                    
                }
                break
            case 2 :
                for tour in filterTours1
                {
                    if Int(tour.length)! > 2
                    {
                        self.filterTours2.append(tour)
                        
                    }
                    
                }
                break
            default:
                for tour in filterTours1
                {
                    if Int(tour.length)! <= 1
                    {
                        self.filterTours2.append(tour)
                        
                    }
                    
                }
                break
            }
                   switch self.Difficulty! {
                    case 0 :
                        
                        for tour in filterTours2
                        {
                            if tour.difficulty == "Pleasant"
                            {
                                self.filterTours3.append(tour)
                                
                            }
                            
                        }
                    break
                    case 1 :
                        for tour in filterTours2
                        {
                            if tour.difficulty == "Brisk"
                            {
                                self.filterTours3.append(tour)
                                
                            }
                            break
                            
                        }
                    break
                    case 2 :
                        for tour in filterTours2
                        {
                            if tour.difficulty == "Workout"
                            {
                                self.filterTours3.append(tour)
                                
                            }
                            
                        }
                    break
                    default:
                        for tour in filterTours2
                        {
                            if tour.difficulty == "Pleasant"
                            {
                                self.filterTours3.append(tour)
                                
                            }
                            

                        }
                    break
                }
        returnValueToCaller?(self.filterTours3)
        navigationController!.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.Rateing=0
        self.Difficulty=0
        self.Length=0
        
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

    //This function returns a cell for a table view, the returned object is of
    //type UITableViewCell. These are the objects that users see in the table's rows.
    //This function basically returns a cell, for a table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            //Return the cell with identifier NotificationTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath as IndexPath) as! RatingTableViewCell
            cell.onButtonTapped={
            
                self.Rateing = cell.rateSegment.selectedSegmentIndex

            
            }

            return cell
        }
        else if indexPath.section == 1{
            //Return the cell with identifier BackTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LengthTableViewCell", for: indexPath as IndexPath) as! LengthTableViewCell
 
            cell.onButtonTapped={
                
                self.Length = cell.lengthSegment.selectedSegmentIndex
                
                
            }

            return cell
            
        }else {
            //Return the cell with identifier AboutTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "DifficultyTableViewCell", for: indexPath as IndexPath)
                as! DifficultyTableViewCell

            cell.onButtonTapped={
                
                self.Difficulty = cell.difficultySegment.selectedSegmentIndex

                
            }

            return cell
            
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section)
        {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch(section) {
        case 0:return "Ratings"
        case 1:return "Trip Length"
        case 2:return "Difficulty"
            
            
        default :return ""
        }

    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow
//        let  currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
//        print(currentCell.reuseIdentifier)
//        currentCell
//    }
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
