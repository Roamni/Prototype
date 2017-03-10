//
//  MyRoamniUserCell.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MyRoamniUserCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!

    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var loginBn: FBSDKLoginButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
