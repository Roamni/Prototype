//
//  ContainerTableViewCell.swift
//  Roamni
//
//  Created by Zihao Wang on 26/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var StarLabel: UILabel!
    @IBOutlet weak var textlabel: UILabel!

    @IBOutlet weak var detailTextlabel: UILabel!
    
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var starrating:CGFloat = 1
    var reviews  = [Review]()
    var tourId : String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    @IBAction func gotoReview(_ sender: Any) {
        //performSegue(withIdentifier: "goToReviews", sender: self)
    }
    
    
//     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToReviews"{
//            //let controller:ReviewsTableViewController = segue.destination as! ReviewsTableViewController
//            let destinationNavigationController = segue.destination as! UINavigationController
//            let targetController = destinationNavigationController.topViewController  as! ReviewsTableViewController
//            targetController.reviews = self.reviews
//            targetController.tourID = self.tourId
//
//        }
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


