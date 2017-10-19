//
//  UserProfileViewController.swift
//  Roamni
//
//  Created by Hyman Li on 17/10/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var titleNavigation: UINavigationBar!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var aboutUser: UITextView!
    var profileuser : User!
    fileprivate var modalVC : DetailViewController!
    
    @IBAction func back(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func goback(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavigation.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        titleNavigation.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //titleNavigation.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height:80)//CGRect(0, 0, self.view.frame.size.width, 40.0)
        //CGFloat navBarHeight = 10
//        let height: CGFloat = 50 //whatever height you want
//        let bounds = titleNavigation.bounds
//       titleNavigation.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        self.navigationController?.navigationBar.frame.size.height = 200
        
        //titleNavigation.frame.size.height = 50
        //titleNavigation.heg
        // Do any additional setup after loading the view.
        userName.text = "\(self.profileuser.firstname) \(self.profileuser.lastname)"
        country.text = self.profileuser.country
        aboutUser.text = self.profileuser.aboutme
        if self.profileuser!.userimage != "image"{
            userImage.loadImageUsingCacheWithUrlString(urlString: "\(self.profileuser!.userimage)")

        }else{
            userImage.image = UIImage(named: "Roamni")
        }
        let color = UIColor.black.cgColor
        aboutUser.layer.borderColor = color
        aboutUser.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

