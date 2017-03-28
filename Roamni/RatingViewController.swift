//
//  ViewController.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit
import Firebase

class RatingViewController: UIViewController, FloatRatingViewDelegate {
    
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var liveLabel: UILabel!
    @IBOutlet var updatedLabel: UILabel!
    var downloadTours = [DownloadTour]()
    var counter = 0
    var ref:FIRDatabaseReference?
    var rating = 3
    var userNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Note: With the exception of contentMode, all of these
            properties can be set directly in Interface builder **/
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 3
        self.floatRatingView.editable = true
        //self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
        // Segmented control init
        //self.ratingSegmentedControl.selectedSegmentIndex = 1
        
        // Labels init
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        
        self.ref = FIRDatabase.database().reference()
        
//       ref?.child("tours").child("\(self.downloadTours[counter].tourId)").observe(.childAdded, with:{ (snapshot) in
//        self.userNumber = Int(snapshot.childSnapshot(forPath: "user").childrenCount)
//        })
        ref?.child("tours").child("\(self.downloadTours[counter].tourId)").child("user").observe(.value, with: {(snapshot) in
            self.userNumber = Int(snapshot.childrenCount)
        
        
        })
        if let user = FIRAuth.auth()?.currentUser{
        let uid = user.uid
        ref?.child("feedbacks").observe(.value, with: {(snapshot) in
            if snapshot.hasChild("\(uid)")
            {
                print("feedbacks provided")
            }
            
        })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submit(_ sender: Any) {
    
        let averageR = (Int(self.downloadTours[counter].star) * (self.userNumber) + self.rating)/(self.userNumber+1)
        self.ref?.child("tours").child("\(self.downloadTours[counter].tourId)").child("star").setValue(averageR)
        
    // check feedback exist or not
        if let user = FIRAuth.auth()?.currentUser{
            let uid = user.uid
        self.ref?.child("tours").child("\(self.downloadTours[counter].tourId)").child("user").child("\(uid)").setValue("rated")
        }
        print(self.downloadTours[counter].tourId)
        let alertController = UIAlertController(title: "Notification", message: "Your rating is submitted", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)

        
    }


    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.rating = Int(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    
}

