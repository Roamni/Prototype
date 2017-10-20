//
//  ReviewDetailViewController.swift
//  Roamni
//
//  Created by Hyman Li on 20/10/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController, FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //
    }
    

    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var reviewRating: FloatRatingView!
    var review : Review!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.reviewRating.r
        let color = UIColor.black.cgColor
        commentText.layer.borderColor = color
        commentText.layer.borderWidth = 1.0
        self.commentText.text = self.review.comment
        self.reviewRating.emptyImage = UIImage(named: "StarEmpty")
        self.reviewRating.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.reviewRating.delegate = self
        self.reviewRating.contentMode = UIViewContentMode.scaleAspectFit
        self.reviewRating.maxRating = 5
        self.reviewRating.minRating = 1
        //Set star rating
        self.reviewRating.rating = self.review.star
        self.reviewRating.editable = false

        // Do any additional setup after loading the view.
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
