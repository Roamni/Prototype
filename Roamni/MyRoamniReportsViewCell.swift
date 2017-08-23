//
//  MyRoamniReportsViewCell.swift
//  Roamni
//
//  Created by Hyman Li on 23/8/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class MyRoamniReportsViewCell: UITableViewCell {

    @IBOutlet weak var moneyField: UILabel!
    @IBOutlet weak var downloadsField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
