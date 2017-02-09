//
//  MyRoamniUploadToursViewController.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class MyRoamniUploadToursViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var FilenameLabel: UILabel!
    var data:NSData?
    var ref:FIRDatabaseReference?
    var pickString:String = "Walking"
    let storage = FIRStorage.storage()
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var endPointLocation:CLLocationCoordinate2D?
    
    @IBOutlet weak var tourNameText: UITextField!
    
    @IBOutlet weak var tourLengthTex: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func dissmissButton(_ sender: Any) {
       
    }
   
       @IBOutlet weak var categoryPicker: UIPickerView!
   
        let categoryPickerValues = ["Walking","Driving","Cycling","Shopping","Accessiable"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickString = categoryPickerValues[row]
    }
    
    @IBOutlet weak var descText: UITextView!
    
    @IBOutlet weak var endPointText: UITextField!
    @IBAction func uploadAction(_ sender: Any) {
        let storageRef = storage.reference()
        if let user = FIRAuth.auth()?.currentUser{
            let uid = user.uid
            let voiceRef = storageRef.child("\(uid)/\(FilenameLabel.text!)")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "voice/m4a"
            let uploadTask = voiceRef.put(data as! Data, metadata: uploadMetadata) { metadata, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL()
                    let downloadurl:String = (downloadURL?.absoluteString)!
                    print(downloadURL)
                   self.ref?.child("tours").childByAutoId().setValue(["name" : self.tourNameText.text!,"TourType":self.pickString,"desc":self.descText.text!,"startPoint":["lat":self.locationManager.location?.coordinate.latitude,"lon":self.locationManager.location?.coordinate.longitude],"endPoint":["lat":self.endPointLocation?.latitude,"lon":self.endPointLocation?.longitude],"star":2,"uploadUser":uid,"downloadURL":downloadurl])
                }
            }
          
            uploadTask.observe(.progress) { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                guard let progress = snapshot.progress else {return}
                strongSelf.progressView.progress  = Float(progress.fractionCompleted)
            }
        }
        else{
            
            print("no user")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)

        self.hideKeyboardWhenTappedAround()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descText.layer.borderWidth = 0.5
        descText.layer.borderColor = borderColor.cgColor
        descText.layer.cornerRadius = 5.0
        self.ref = FIRDatabase.database().reference()
        categoryPicker.delegate = self
        categoryPicker.delegate = self
        self.mapView.delegate = self
        self.locationManager.delegate = self
        mapView.showsUserLocation = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        let span = MKCoordinateSpanMake(0.0018, 0.0018)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), span: span)
        mapView.setRegion(region, animated: true)


        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began{
            let touchPoint = sender.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            self.endPointLocation = annotation.coordinate
            annotation.title = "EndPoint"
            self.mapView.removeAnnotations(mapView.annotations)
            self.mapView.addAnnotation(annotation)
            self.endPointText.text = annotation.title
        }
        
    }
//    func addAnnotation(gestureRecognizer:UILongPressGestureRecognizer){
////        let touchPoint = gestureRecognizer.location(in: mapView)
////        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
////        let annotation = MKPointAnnotation()
////        annotation.coordinate = newCoordinates
////        mapView.addAnnotation(annotation)
//        if gestureRecognizer.state == UIGestureRecognizerState.began{
//            let touchPoint = gestureRecognizer.location(in: mapView)
//            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = newCoordinates
//            
//            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude:newCoordinates.latitude, longitude:newCoordinates.longitude), completionHandler: {(placemarks,error) -> Void in
//                if error != nil {
//                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//                    return
//                }
//                if (placemarks?.count)! > 0 {
//                    let pm = (placemarks?[0])! as CLPlacemark
//                    // not all places have thoroughfare & subThoroughfare so validate those values
//                    annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
//                    annotation.subtitle = pm.subLocality
//                    self.mapView.addAnnotation(annotation)
//                    print(pm)
//                    
//                }
//                else {
//                    annotation.title = "Unknown Place"
//                    self.mapView.addAnnotation(annotation)
//                    print("Problem with the data received from geocoder")
//                }
//                
//            })
//        }
//        
//    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        else{
            let pinIdent = "Pin"
            var pinView:MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            }
            else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            return pinView
        }
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
