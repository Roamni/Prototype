//
//  DifficultyTableViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 21/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class DifficultyTableViewCell: UITableViewCell {
    var onButtonTapped : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        (difficultySegment.subviews[0] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (difficultySegment.subviews[1] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (difficultySegment.subviews[2] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)

    }

    @IBOutlet weak var difficultySegment: UISegmentedControl!
    
    @IBAction func difficultSeg(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
