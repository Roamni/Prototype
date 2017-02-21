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
final class ModalViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var player = AVAudioPlayer()
    var downloadTours = [DownloadTour]()
    var counter = 0
    var tapCloseButtonActionHandler : ((Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubview(toBack: blurView)
    
    }
    
    @IBAction func tapCloseButton() {
        self.tapCloseButtonActionHandler?()
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        print("play")
        if playBtn.currentImage == UIImage(named: "songplay"){
            playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
        }else{
            playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        print("ModalViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ModalViewController viewWillDisappear")
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
        
        //        musicSlider.maximumValue = Float(player.duration)
        //        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateMusicSlider), userInfo: nil, repeats: true)
        player.delegate = self
        if error == nil {
            //       print("is playing!!!")
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }
        
        
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

    
}
