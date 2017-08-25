//
//  MyRoamniEditToursViewController.swift
//  Roamni
//
//  Created by Hyman Li on 20/7/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class MyRoamniEditToursViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UITextViewDelegate {

    var tourId : String!
    
    @IBAction func startButton(_ segue: UIStoryboardSegue) {
        let secondVC :ViewController = segue.source as! ViewController
        if (secondVC.anno == nil)
        {
            
            self.alertBn(title: "Error", message: "Please select a Pin")
            
        }
        else{
            
            self.mapView.addAnnotation(secondVC.anno!)
            
            if secondVC.sender == "startPoint" {
                
                self.startPointLocation = secondVC.anno?.coordinate
                print(self.startPointLocation)
                self.startpointBn.tintColor = UIColor.black
                
                self.startpointBn.setTitle((secondVC.anno?.title)!, for: .normal)
            }
            else{
                self.endPointLocation = secondVC.anno?.coordinate
                print(self.endPointLocation)
                self.endPointBn.setTitle((secondVC.anno?.title)!, for: .normal)
                self.endPointBn.tintColor = UIColor.black
                
            }
        }
    }
    
    @IBAction func categoryButton(_ segue: UIStoryboardSegue) {
        let secondVC :UploadPickerViewController = segue.source as! UploadPickerViewController
        self.categoryBn.setTitle(secondVC.pickString, for: .normal)
        self.categoryBn.tintColor = UIColor.black
    }
    
    @IBAction func lengthButton(_ segue: UIStoryboardSegue) {
        let secondVC :UploadLengthViewController = segue.source as! UploadLengthViewController
        self.lengthBn.setTitle(secondVC.pickString, for: .normal)
        self.lengthBn.tintColor = UIColor.black
        print((self.lengthBn.titleLabel?.text)!)
    }
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var categoryBn: UIButton!
    
    @IBOutlet weak var naviBar: UINavigationBar!
    
    @IBOutlet weak var startpointBn: UIButton!
    
    @IBOutlet weak var endPointBn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var FilenameLabel: UILabel!
    
    @IBOutlet weak var lengthBn: UIButton!
    
    var data:NSData?
    var getText:String? = nil
    var ref:FIRDatabaseReference?
    let storage = FIRStorage.storage()
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var endPointLocation:CLLocationCoordinate2D?
    var startPointLocation:CLLocationCoordinate2D?
    @IBOutlet weak var tourNameText: UITextField!
    
    @IBOutlet weak var tourLengthTex: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func cancleButton(_ sender: Any) {
        self.deregisterFromKeyboardNotifications()
        
    }
    
    @IBAction func naviCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBOutlet weak var cancelBn: UIBarButtonItem!
    
    @IBOutlet weak var descText: UITextView!
    
    @IBOutlet weak var endPointText: UITextField!
    @IBAction func uploadAction(_ sender: Any) {
        

           if (self.tourNameText.text?.isEmpty)! || (self.getText?.isEmpty)! || self.startPointLocation == nil || self.endPointLocation == nil
            {
                print("alert!")
                let alertController = UIAlertController(title: "Error", message:
                    "please input all field", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
           }
            else
            {

        let nameRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/name")
        nameRef.setValue(self.tourNameText.text)
        let typeRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/TourType")
        typeRef.setValue(self.categoryBn.titleLabel?.text)
        let descRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/desc")
        
        descRef.setValue(getText)
        let lengthRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/duration")
        print(self.lengthBn.titleLabel?.text!)
        //Int((self.lengthBn.titleLabel?.text)!
        lengthRef.setValue(Int((self.lengthBn.titleLabel?.text)!))
        let endLatRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/endPoint/lat")
        endLatRef.setValue(self.endPointLocation?.latitude)
        let endLonRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/endPoint/lon")
        endLonRef.setValue(self.endPointLocation?.longitude)
        let startLatRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/startPoint/lat")
        startLatRef.setValue(self.startPointLocation?.latitude)
        let startLonRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("tours/\(self.tourId!)/startPoint/lon")
        startLonRef.setValue(self.startPointLocation?.longitude)
                let alertController = UIAlertController(title: "complete ", message: "Uploading Successful", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: self.handleok)
                
                alertController.addAction(ok)
                self.dismiss(animated: false, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    func checkLogin() -> Void {
        if let user = FIRAuth.auth()?.currentUser{
        }else
        {
            let refreshAlert = UIAlertController(title: "Reminder ", message: "Please log in to uploading ", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Go to Login", style: .default, handler: { (action: UIAlertAction!) in
                let controller  =   self.storyboard?.instantiateViewController(withIdentifier: "firstView") as! testViewController
                
                controller.modalPresentationStyle = .overCurrentContext
                controller.goMyRoamni = true
                self.present(controller, animated: true, completion: nil)
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func handleok(action: UIAlertAction){
        let controller  =   self.storyboard?.instantiateViewController(withIdentifier: "firstView") as! testViewController
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.goMyTour = true
        self.dismiss(animated: false, completion: nil)
        self.present(controller, animated: true, completion: nil)
        
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
        if let descText = self.descText {
            if (!aRect.contains(descText.frame.origin)){
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descText = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        descText = nil
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
        self.descText.delegate = self
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descText.layer.borderWidth = 0.5
        descText.layer.borderColor = borderColor.cgColor
        descText.layer.cornerRadius = 5.0
        self.ref = FIRDatabase.database().reference()
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
        mapView.tintColor = UIColor.blue
        self.startpointBn.tintColor = UIColor.blue
        self.endPointBn.tintColor = UIColor.blue
        self.startpointBn.setTitle("click to set a new start Point", for: .normal)
        self.endPointBn.setTitle("click to set a new end Point", for: .normal)
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
            
        }
        self.naviBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        self.naviBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UITextField.appearance().tintColor = UIColor.black
        UITextView.appearance().tintColor = UIColor.black
        self.cancelBn.tintColor = UIColor.white
        self.descText.returnKeyType = UIReturnKeyType.done
        

    }
    

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startPoint"{
            let navigationController:UINavigationController = segue.destination as! UINavigationController
            let controller:ViewController = navigationController.topViewController as! ViewController
            controller.sender = "startPoint"
        }
        if segue.identifier == "endPoint"{
            let navigationController:UINavigationController = segue.destination as! UINavigationController
            let controller:ViewController = navigationController.topViewController as! ViewController
            controller.sender = "endPoint"
            
        }
    }
    
}
extension MyRoamniEditToursViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
