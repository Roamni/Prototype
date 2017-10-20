//
//  AddReviewViewController.swift
//  Roamni
//
//  Created by Hyman Li on 20/10/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase

class AddReviewViewController: UIViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var reviewText: UITextView!
    var tourID : String!
    var rating = 3
    
    @IBAction func submitReview(_ sender: Any) {
        if self.reviewText.text == "" {
            self.alertBn(title: "warning", message: "Please input your review")
            
        }
        else{
            //var emial : String!
        var ref:FIRDatabaseReference?
       ref = FIRDatabase.database().reference()
            if let user = FIRAuth.auth()?.currentUser{
                
               let emial = user.email!
                ref?.child("Reviews").childByAutoId().setValue(["review":self.reviewText.text!,"tourid":tourID,"reviewUser":emial,"rating":tourID])
            }
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor.black.cgColor
        reviewText.layer.borderColor = color
        reviewText.layer.borderWidth = 1.0
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.rating = Int(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
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
