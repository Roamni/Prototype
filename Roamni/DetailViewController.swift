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

class DetailViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var detailMap: MKMapView!
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    var detailTour: Tour?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
    
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    //configureView()
    self.titleLabel.text = detailTour?.name
    self.titleLabel.adjustsFontSizeToFitWidth = true

    //self.title = detailTour?.name
    self.lengthLabel.text = detailTour?.length
    self.ratingLabel.text = detailTour?.star
    self.descLabel.text = detailTour?.desc
    detailMap.delegate = self
    let sourceLocation = detailTour?.locations
    let destinationLocation = CLLocationCoordinate2D(latitude: -37.8378656, longitude: 144.9823664)
    let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
    let sourceMapItem =  MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    let sourceAnnotation = MKPointAnnotation()
    sourceAnnotation.title = detailTour?.name
    if let location = sourcePlacemark.location{
        sourceAnnotation.coordinate = location.coordinate
    }
    let destinationAnnotation = MKPointAnnotation()
    destinationAnnotation.title = "destination"
    if let location = destinationPlacemark.location{
        destinationAnnotation.coordinate = location.coordinate
    }
    self.detailMap.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
    let directionRequest = MKDirectionsRequest()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .any
    let directions = MKDirections(request: directionRequest)
    directions.calculate {(response, error) -> Void in
        guard let response = response else
        {
            if let error = error {
                print("Error: \(error)")
            }
            return
        }
                    let route = response.routes[0]
                    self.detailMap.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
                    self.detailMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
            }
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
  
}

