//
//  ModalViewController.swift
//  MusicPlayerTransition
//
//  Created by xxxAIRINxxx on 2015/02/25.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import MediaPlayer
import CoreLocation

final class ModalViewController: UIViewController, AVAudioPlayerDelegate,CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var startedTime: UILabel!
   // @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var player : AVAudioPlayer!
    var downloadTours = [DownloadTour]()
    var counter = 0
    var tapCloseButtonActionHandler : ((Void) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicSlider.value = 0.0
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubview(toBack: blurView)

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            print("Receiving remote control events\n")
        } catch {
            print("Audio Session error.\n")
        }


    }
    
    @IBAction func next(_ sender: Any) {
        print("next")
//        if self.counter != downloadTours.count - 1{
//            self.counter = self.counter + 1
//        }else{
//            self.counter = 0
//        }
        playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        player.pause()
        player.currentTime = player.currentTime + 15
        player.play()

    }
    
    @IBAction func previous(_ sender: Any) {
        print("pervious")
//        if self.counter != 0{
//            self.counter = self.counter - 1
//        }else{
//            self.counter = downloadTours.count - 1
//        }
        playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        player.pause()
        player.currentTime = player.currentTime - 15
        player.play()

    }
    
    
    @IBAction func tapCloseButton() {
       // self.tapCloseButtonActionHandler?()
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        print("play")
        if playBtn.currentImage == UIImage(named: "songplay"){
            playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
            player.play()
            setLockView()
        }else{
            playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
            player.pause()
            setLockView()
        }
    }
    


    @IBAction func sliderAction(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(musicSlider.value)
        player.play()
        playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        setLockView()
    }
    
    
    func updateTourDetail(){
        songTitle.text = downloadTours[counter].name
        let sourceLocation = downloadTours[counter].startLocation
        let destinationLocation = CLLocationCoordinate2D(latitude: (downloadTours[counter].endLocation.latitude), longitude: (downloadTours[counter].endLocation.longitude))
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem =  MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        //sourceAnnotation.title = detailTour?.name
        if let location = sourcePlacemark.location{
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "destination"
        if let location = destinationPlacemark.location{
            destinationAnnotation.coordinate = location.coordinate
        }
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
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
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        player = delegate.player
        downloadTours = delegate.downloads
        if player.isPlaying{
            playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        }
        print("ModalViewController viewWillAppear")
        musicSlider.maximumValue = Float(self.player.duration)
        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ModalViewController.updateMusicSlider), userInfo: nil, repeats: true)
        updateTourDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ModalViewController viewWillDisappear")
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
    
    
    @IBAction func more(_ sender: Any) {
        self.performSegue(withIdentifier: "moredetail", sender: self)
    }
    

    
    func music(){
        // isPlaying = true
        // print("counter is \(counter)")
        //let audioPath = Bundle.main.path(forResource: "\(counter)", ofType: "m4a")!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.downloads.count != 0{
            delegate.player.stop()
        }

        let error : NSError? = nil
        //player = AVAudioPlayer(contentsOfURL: URL(string: audioPath), error: error)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let filePath = "file:\(documentsDirectory)/voices/\(self.downloadTours[self.counter].name).m4a"
        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        do {
            player = try AVAudioPlayer(contentsOf: fileURL!)
            print("hello")
        } catch {
            print("couldn't load file :(")
            
        }
        
        player.delegate = self
        if error == nil {
            //       print("is playing!!!")
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }
        

        delegate.player = player
        delegate.songTitle = downloadTours[counter].name
        delegate.downloads = downloadTours
        print("player is \(self.player)")

        
    }
    
    
    func updateMusicSlider(){
        
        musicSlider.value = Float(player.currentTime)
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(player.currentTime))
        startedTime.text = "\(h):\(m):\(s)"//"\(Int(player.currentTime))"
        let (h1,m1,s1) = secondsToHoursMinutesSeconds(seconds: Int(player.duration) -  Int(player.currentTime))
        leftTime.text = "\(h1):\(m1):\(s1)"//"\(Int(player.duration) -  Int(player.currentTime))"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setLockView(){
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle:"\(downloadTours[counter].name)",
            MPMediaItemPropertyArtist:"\(downloadTours[counter].difficulty)",
            MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: UIImage(named: "img.jpeg")!),
            MPNowPlayingInfoPropertyPlaybackRate:1.0,
            MPMediaItemPropertyPlaybackDuration:player.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime:player.currentTime
        ]
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch event!.subtype {
        case .remoteControlPlay:  // play
            player.play()
            playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        case .remoteControlPause:  // pause
            player.pause()
            playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
            print("pausepause")
        case .remoteControlNextTrack:  // next
            player.pause()
            player.currentTime = player.currentTime + 15
            player.play()
            setLockView()
            break
        case .remoteControlPreviousTrack:  // previous
            player.pause()
            player.currentTime = player.currentTime - 15
            player.play()
            setLockView()
            break
        default:
            break
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("Called")
        playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
//        if flag {
//            
//            if self.counter != downloadTours.count - 1{
//                self.counter = self.counter + 1
//            }else{
//                self.counter = 0
//            }
//        music()
//        musicSlider.maximumValue = Float(self.player.duration)
//        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ModalViewController.updateMusicSlider), userInfo: nil, repeats: true)
//        setLockView()
//        }
//        updateTourDetail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moredetail"
        {
            let navController = segue.destination as! UINavigationController
            let controller: TourMusicDetailViewController = navController.viewControllers[0] as! TourMusicDetailViewController

            
            controller.tour = downloadTours[counter]
            controller.counter = self.counter
            controller.downloadTours = self.downloadTours
            //controller.downloadTours = self.downloadTours
            print("calling!!")
  
            
            //controller.music()
            //controller.setLockView()
            // self.musictitle = downloadTours[counter].name
            // self.musicartist = downloadTours[counter].difficulty
            
            
        }
        
        
    }
   
    
}
