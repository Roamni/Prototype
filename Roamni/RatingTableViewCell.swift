//
//  RatingTableViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 21/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    var rating:Int?
    var onButtonTapped : (() -> Void)? = nil
    @IBOutlet weak var rateSegment: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        (rateSegment.subviews[0] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (rateSegment.subviews[1] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (rateSegment.subviews[2] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        // Initialization code
    }
    
    @IBAction func ratingSegmentControl(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
