//
//  MyRoamniReviewTableViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 20/10/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class MyRoamniReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var reviewRating: FloatRatingView!
    
    @IBOutlet weak var reviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.reviewRating.emptyImage = UIImage(named: "StarEmpty")
//        self.reviewRating.fullImage = UIImage(named: "StarFull")
//        // Optional params
//        self.reviewRating.delegate = self as! FloatRatingViewDelegate
//        self.reviewRating.contentMode = UIViewContentMode.scaleAspectFit
//        self.reviewRating.maxRating = 5
//        self.reviewRating.minRating = 1
//        self.reviewRating.rating = 3
//        self.reviewRating.editable = false
//        //self.floatRatingView.halfRatings = true
//        self.reviewRating.floatRatings = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
