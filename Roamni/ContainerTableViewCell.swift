//
//  ContainerTableViewCell.swift
//  Roamni
//
//  Created by Zihao Wang on 26/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var StarLabel: UILabel!
    @IBOutlet weak var textlabel: UILabel!

    @IBOutlet weak var detailTextlabel: UILabel!
    
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var starrating:CGFloat = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


