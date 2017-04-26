//
//  ContainerMapViewController.swift
//  Roamni
//
//  Created by Hyman Li on 18/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
class ContainerMapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var tours = [DownloadTour]()
    var places = [TourForMap]()
    var aTour : TourForMap?
    var realTour: DownloadTour?
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.locationManager.delegate = self
        
        
        
        // Ask user for permission to use location
        // Uses description from NSLocationAlwaysUsageDescription in Info.plist
       // locationManager.requestAlwaysAuthorization()
        
        
        self.mapView.showsUserLocation = true
        
        
        mapView.showsUserLocation = true
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        let span = MKCoordinateSpanMake(0.0018, 0.0018)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), span: span)
        mapView.setRegion(region, animated: true)


    }
    
    @IBAction func backToCurrentLocation(_ sender: Any) {
        mapView.delegate = self
        
        self.locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.mapView.showsUserLocation = true
        mapView.showsUserLocation = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        let span = MKCoordinateSpanMake(0.0018, 0.0018)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), span: span)
        mapView.setRegion(region, animated: true)


    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidLoad()
                //self.places.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        for thetour in tours{
            let place = TourForMap(title: thetour.name, info: thetour.tourType, coordinate: thetour.startLocation)
            places.append(place)
        }
        
        mapView.addAnnotations(places)
        //fetchTours()

        // Do any additional setup after loading the view.
    }
       
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Set the event when the users tap on an annoatation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //Perform segue when users tap on annotations
        if control === view.rightCalloutAccessoryView {
            self.aTour = view.annotation as? TourForMap
            performSegue(withIdentifier: "goToDetail", sender: self)
        
            
        }
    }
    
    //Set pin`s look and pin event
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Let each annotation as CategoryForMap
        print("whatwhatwhat?")
        if let annotation = annotation as? TourForMap{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                
                
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            return view
        }
        return nil
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"
        {
            let controller:DetailViewController = segue.destination as! DetailViewController
            var i = 0
            for tour in tours{
                
                if aTour?.title == tour.name
                {
                    
                    self.realTour = tour
                    break
                }
                i += 1
            }
            controller.detailTour = self.realTour
            controller.allDetailTour = tours
            controller.currentIndex = i
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
}
