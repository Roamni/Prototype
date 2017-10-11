//
//  MyRoamniUserCell.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
class MyRoamniUserCell: UITableViewCell {
    @IBOutlet weak var userLabel: UILabel!

    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var logoutBn: UIButton!
    @IBOutlet weak var loginBn: FBSDKLoginButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func logout(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: MyRoamniLogViewController = storyboard.instantiateViewController(withIdentifier: "MyRoamniLogViewController") as! MyRoamniLogViewController
                //present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
