

//
//  FeedbackViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 17/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
class FeedbackViewController: UIViewController,FloatRatingViewDelegate,UITextViewDelegate{

    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var textv: UITextView!
    
    @IBAction func submitBn(_ sender: Any) {
        if self.getText == nil{
            self.alertBn(title: "Error", message: "Please input the comments")
        
        }
        else{
            if let user = FIRAuth.auth()?.currentUser{
                let uid = user.uid
        self.ref?.child("feedbacks").child("\(uid)").setValue(["star":self.rating,"comments":self.getText!])
            }
        let alertController = UIAlertController(title: "Notification", message: "Your rating is submitted", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var ref:FIRDatabaseReference?
    var rating = 3
    var userNumber = 0
    var getText:String?=nil
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textv = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textv = nil
    }
    func textViewDidChange(_ textView: UITextView) {
        self.getText = textView.text
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textv.delegate = self
        UITextView.appearance().tintColor = UIColor.black
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textv.layer.borderWidth = 0.5
        textv.layer.borderColor = borderColor.cgColor
        textv.layer.cornerRadius = 5.0
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
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.rating = Int(self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
    }

}
