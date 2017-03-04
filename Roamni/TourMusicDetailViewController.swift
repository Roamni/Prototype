//
//  TourMusicDetailViewController.swift
//  Roamni
//
//  Created by Hyman Li on 24/2/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class TourMusicDetailViewController: UIViewController {

    @IBOutlet weak var ratingbtn: UIBarButtonItem!
    @IBOutlet weak var backbtn: UIBarButtonItem!
    var tour: DownloadTour?
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desc: UITextView!
    var downloadTours = [DownloadTour]()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
      
        // Do any additional setup after loading the view.
        backbtn.tintColor = UIColor.white
        ratingbtn.tintColor = UIColor.white
        desc.text = tour?.desc
        diffLabel.text = tour?.difficulty
        nameLabel.text = tour?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ratingSeg"
        {
            let controller = segue.destination as! RatingViewController
            //let controller: RatingViewController = navController.viewControllers[0] as! RatingViewController
            
            
            //controller.co = downloadTours[counter]
            controller.downloadTours = self.downloadTours
            controller.counter = self.counter
            print("calling!!")
            
            
            //controller.music()
            //controller.setLockView()
            // self.musictitle = downloadTours[counter].name
            // self.musicartist = downloadTours[counter].difficulty
            
            
        }
        
        
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
