//
//  LengthTableViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 21/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class LengthTableViewCell: UITableViewCell {

    var onButtonTapped : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        (lengthSegment.subviews[0] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (lengthSegment.subviews[1] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        (lengthSegment.subviews[2] as UIView).tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        // Initialization code
    }
    @IBOutlet weak var lengthSegment: UISegmentedControl!

    @IBAction func lenghtSeg(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
