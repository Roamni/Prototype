//
//  MyRoamniIncomingRequestDetail.swift
//  Roamni
//
//  Created by Zihao Wang on 2/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import MapKit

class MyRoamniIncomingRequestDetail: UIViewController {
    var detailTour: Tour?

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var attractionLb: UILabel!
    
    @IBOutlet weak var DescriptionLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attractionLb.text = self.detailTour?.attraction
        self.DescriptionLb.text = self.detailTour?.desc
        let annotation = MKPointAnnotation()
        annotation.coordinate = (self.detailTour?.locations)!
        annotation.title = self.detailTour?.attraction
        self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake((self.detailTour?.locations)!, span)
        mapView.setRegion(region, animated: true)

    
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
