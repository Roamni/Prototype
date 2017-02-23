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
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var startedTime: UILabel!
    @IBOutlet weak var musicSlider: UISlider!
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
        if self.counter != downloadTours.count - 1{
            self.counter = self.counter + 1
        }else{
            self.counter = 0
        }

        player.stop()
        music()
        musicSlider.maximumValue = Float(self.player.duration)
        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ModalViewController.updateMusicSlider), userInfo: nil, repeats: true)
        setLockView()
        updateTourDetail()
    }
    
    @IBAction func previous(_ sender: Any) {
        print("pervious")
        if self.counter != 0{
            self.counter = self.counter - 1
        }else{
            self.counter = downloadTours.count - 1
        }

        player.stop()
        music()
        musicSlider.maximumValue = Float(self.player.duration)
        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ModalViewController.updateMusicSlider), userInfo: nil, repeats: true)
        setLockView()
        print("\(downloadTours.count)")
        updateTourDetail()
    }
    
    
    @IBAction func tapCloseButton() {
       // self.tapCloseButtonActionHandler?()
        
     //   self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        print("play")
        if playBtn.currentImage == UIImage(named: "songplay"){
            playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
            player.play()
        }else{
            playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
            player.pause()
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
        let destinationLocation = CLLocationCoordinate2D(latitude: (downloadTours[counter].endLocation.latitude), longitude: (downloadTours[counter].endLocation.latitude))
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
    
    
    func music(){
        // isPlaying = true
        // print("counter is \(counter)")
        //let audioPath = Bundle.main.path(forResource: "\(counter)", ofType: "m4a")!
        let error : NSError? = nil
        //player = AVAudioPlayer(contentsOfURL: URL(string: audioPath), error: error)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let filePath = "file:\(documentsDirectory)/voices/\(self.downloadTours[self.counter].name).m4a"
        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        do {
            print(fileURL)
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
        
        var delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.player = player
        delegate.songTitle = downloadTours[counter].name
        delegate.downloads = downloadTours
        print("player is \(self.player)")

        
    }
    
    
    func updateMusicSlider(){
        
        musicSlider.value = Float(player.currentTime)
        startedTime.text = "\(Float(player.currentTime))"
        leftTime.text = "\(Float(player.duration) -  Float(player.currentTime))"
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
        case .remoteControlPlay:  // play按钮
            player.play()
        case .remoteControlPause:  // pause按钮
            player.pause()
        case .remoteControlNextTrack:  // next
            // ▶▶ 押下時の処理
            break
        case .remoteControlPreviousTrack:  // previous
            // ◀◀ 押下時の処理
            break
        default:
            break
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("Called")
        if flag {
            
            if self.counter != downloadTours.count - 1{
                self.counter = self.counter + 1
            }else{
                self.counter = 0
            }
        music()
        musicSlider.maximumValue = Float(self.player.duration)
        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ModalViewController.updateMusicSlider), userInfo: nil, repeats: true)
        setLockView()
        }
        updateTourDetail()
    }
   
    
}
