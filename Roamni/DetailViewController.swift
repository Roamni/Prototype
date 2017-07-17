/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import MapKit
import Firebase
import AVFoundation
class DetailViewController: UIViewController, MKMapViewDelegate, FloatRatingViewDelegate {
    /**
     Returns the rating value when touch events end
     */
    public func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
    }

    var ref:FIRDatabaseReference?
    var detailTour: DownloadTour?
    var allDetailTour = [DownloadTour]()
    var users:[String]?
    var currentIndex:Int?
    var aPlayer:AVPlayer!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var detailMap: MKMapView!
    
    @IBOutlet weak var nextBn: UIBarButtonItem!
    @IBOutlet weak var preBn: UIBarButtonItem!
       
    
    @IBAction func nextAc(_ sender: Any) {
        self.detailTour = self.allDetailTour[currentIndex!+1]
        self.currentIndex! += 1
        self.viewDidLoad()

    }
    @IBAction func preAc(_ sender: Any) {
        if currentIndex != 0{
        self.detailTour = self.allDetailTour[currentIndex!-1]
        self.currentIndex! -= 1
        }
        self.viewDidLoad()

    }
    

    
    @IBAction func preViewBn(_ sender: Any) {
        var timeObserver: AnyObject!
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        aPlayer = AVPlayer(url: NSURL(string: (self.detailTour?.downloadUrl)!)! as URL)
        let timeInterval: TimeInterval = 10.0
        let cmtime:CMTime = CMTimeMake(Int64(timeInterval), 1)
        let timeArray = NSValue(time: cmtime)
        timeObserver = aPlayer.addBoundaryTimeObserver(forTimes: [timeArray], queue:nil) { () -> Void in
            print("10s reached")
            self.alertBn(title: "complete", message: "30 seconds reached")
//            self.aPlayer.removeTimeObserver(timeObserver)
               self.aPlayer.pause()
            
            //self.aPlayer = nil
            } as AnyObject!
        aPlayer.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        var player : AVAudioPlayer! = nil
        let delegate = UIApplication.shared.delegate as! AppDelegate
        player = delegate.player
        if player != nil{
        player.pause()
        }
        aPlayer.play()

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if aPlayer.currentItem?.status == AVPlayerItemStatus.readyToPlay{
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            aPlayer.currentItem?.removeObserver(self, forKeyPath: "status")
        }
        
    }
  
    @IBAction func downloadAction(_ sender: Any) {
        if let user = FIRAuth.auth()?.currentUser{
            let uid = user.uid
            self.ref = FIRDatabase.database().reference()
            let detaiTourId = self.detailTour?.tourId
            ref?.child("tours").child("\(detaiTourId!)").child("user").observe(.value, with:{ (snapshot) in
                if !snapshot.hasChild(uid){
                 self.ref?.child("tours").child("\(detaiTourId!)").child("user").child(uid).setValue("buy")
                }
            })
        self.alertBn(title: "Successful", message: "You have added this tour to your Mytour list")
        }
        else {
            self.alertBn(title: "Error", message: "Please Log in")
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.detailMap.annotations.count != 0
    {

        self.detailMap.removeAnnotations(self.detailMap.annotations)
    }
    navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
    
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    //configureView()
    self.titleLabel.text = detailTour?.name
    self.titleLabel.adjustsFontSizeToFitWidth = true
    //
    if currentIndex == self.allDetailTour.count-1{
        self.nextBn.isEnabled = false
    }
    else{
        self.nextBn.isEnabled = true
    }
    if currentIndex == 0{
        self.preBn.isEnabled = false
    }
    else
    {
        self.preBn.isEnabled = true
    }

    //self.title = detailTour?.name
    self.lengthLabel.text = String(detailTour?.length ?? 0)
    self.ratingLabel.text = String(describing: detailTour?.star)
    self.descLabel.text = detailTour?.desc
    detailMap.delegate = self
    let sourceLocation = detailTour?.startLocation
    self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
    self.floatRatingView.fullImage = UIImage(named: "StarFull")
    // Optional params
    self.floatRatingView.delegate = self
    self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
    self.floatRatingView.maxRating = 5
    self.floatRatingView.minRating = 1
    //Set star rating
    self.floatRatingView.rating = (detailTour?.star)!
    self.floatRatingView.editable = false
    
    let destinationLocation = CLLocationCoordinate2D(latitude: (detailTour?.endLocation.latitude)!, longitude: (detailTour?.endLocation.longitude)!)
    let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
    let sourceMapItem =  MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    let sourceAnnotation = MKPointAnnotation()
    sourceAnnotation.title = detailTour?.name
    if let location = sourcePlacemark.location{
        sourceAnnotation.coordinate = location.coordinate
    }
    let place = TourForMap(title: sourceAnnotation.title!, info: "Start Point", coordinate: sourceAnnotation.coordinate)
    detailMap.addAnnotation(place)

    
    //self.detailMap.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    //places.append(place)
    
    let destinationAnnotation = MKPointAnnotation()
    destinationAnnotation.title = "Destination"
    if let location = destinationPlacemark.location{
        destinationAnnotation.coordinate = location.coordinate
    }
    self.detailMap.showAnnotations([/*sourceAnnotation,*/destinationAnnotation], animated: true)
    let directionRequest = MKDirectionsRequest()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .any
   // let directions = MKDirections(request: directionRequest)
//    directions.calculate {(response, error) -> Void in
//        guard let response = response else
//        {
//            if let error = error {
//                print("Error: \(error)")
//            }
//            return
//        }
//                    let route = response.routes[0]
//                    self.detailMap.add(route.polyline, level: MKOverlayLevel.aboveRoads)
//            let rect = route.polyline.boundingMapRect
//                    self.detailMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//            
//            }
    let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    self.detailMap.setRegion(region, animated: true)
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
        
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
                //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.pinTintColor = UIColor.green
            return view
        }
        return nil
    }

    

}

