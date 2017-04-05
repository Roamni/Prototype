//
//  MyRoamniRequestTourViewController.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MyRoamniRequestTourViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var tourPicker: UIPickerView!
    
    @IBOutlet weak var AttraTxetField: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBAction func submitRequest(_ sender: Any) {
        if self.anno != nil{

        self.ref?.child("requestTours").childByAutoId().setValue(["Attraction":self.AttraTxetField.text!,"startPoint":["lat":self.startPointLocation?.latitude,"lon":self.startPointLocation?.longitude],"TourType":self.pickString,"desc":self.getText!])
            dismiss(animated: true, completion: nil)
        }
        else{
            self.alertBn(title: "warning", message: "Please drop a pin ")
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func BackView(_ sender: Any) {
        self.deregisterFromKeyboardNotifications()
        dismiss(animated: true, completion: nil)
    }
    
    var pickString:String = "Walking"
    var startPointLocation:CLLocationCoordinate2D?
    var getText:String?
    var ref:FIRDatabaseReference?
    var anno:MKAnnotation?
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var sender:String?
    let locationManager = CLLocationManager()
    let tourPickerValues = ["Walking","Driving","Cycling","Shopping","Accessiable"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descTextView.layer.borderWidth = 0.5
        descTextView.layer.borderColor = borderColor.cgColor
        descTextView.layer.cornerRadius = 5.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.tintColor = UIColor.blue
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        
        locationSearchTable.HandleSearchDelegate = self

        self.tourPicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        self.descTextView.delegate = self
        self.AttraTxetField.delegate = self
        // Do any additional setup after loading the view.
    }
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let descText = self.descTextView {
            if (aRect.contains(descText.frame.origin)){
                self.scrollView.scrollRectToVisible(descText.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
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

extension MyRoamniRequestTourViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}
extension MyRoamniRequestTourViewController: HandleSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        self.anno = annotation
        self.startPointLocation = annotation.coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}
extension MyRoamniRequestTourViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
//        button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}
extension MyRoamniRequestTourViewController:UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tourPickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tourPickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickString = tourPickerValues[row]
    }

}
extension MyRoamniRequestTourViewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descTextView = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        descTextView = nil
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
}
extension MyRoamniRequestTourViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
