//
//  MyRoamniMyProfileTableViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 29/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class MyRoamniMyProfileTableViewCell: UITableViewCell, FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
    }
    

    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var tourName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rating.emptyImage = UIImage(named: "StarEmpty")
        self.rating.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.rating.delegate = self
        self.rating.contentMode = UIViewContentMode.scaleAspectFit
        self.rating.maxRating = 5
        self.rating.minRating = 1
        //Set star rating
        self.rating.editable = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
